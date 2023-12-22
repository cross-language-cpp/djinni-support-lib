import requests
import pprint
import re
import sys
import zipfile
import os
import platform

import traceback

""" Download djinni generator from the last successful check of a pull request.

    Usage: python get-generator-from-pr.py <PR number>
    Example: python get-generator-from-pr.py 123

    It's unfortunately not possible to download artifacts from a pull request directly.
    So there are a few steps involved:
    1. Get the commits for the pull request
    2. Get the checks for the last commit
    3. Find the last successful check
    4. Extract the workflow run ID from the details URL
    5. Get the list of artifacts for the workflow run
    6. Get the ID of the last artifact
    7. Download the last artifact
    8. Unzip the file
    9. Make the file executable (on Linux and Mac)
    10. Run the generator
"""

# Get the token from the environment variable
TOKEN_ENV_VAR='GENERATOR_DL_TOKEN'
TOKEN = os.getenv(TOKEN_ENV_VAR)
if TOKEN is None:
    sys.exit(f'{TOKEN_ENV_VAR} environment variable not set')

print(f'Using token: {TOKEN}')
print(f'Using token with : {len(TOKEN)} chars')

output_dir = 'zz'


# For 'debugging' the JSON response
def dbg_print(data):
    print('------------------')
    pprint.pprint(data)
    print('------------------')



def download_file(url, outdir, filename, headers=None):

    if not os.path.exists(outdir):
        os.mkdir(outdir)
    # print(f'Downloading from URL: {url}')
    response = requests.get(url, stream=True, headers=headers)
    # print(f'Response status code: {response.status_code}')
    response.raise_for_status()
    full_path = os.path.join(outdir, filename)
    with open(full_path, 'wb') as f:
        for chunk in response.iter_content(chunk_size=8192):
            f.write(chunk)
    # print(f'File downloaded successfully: {filename}')
    return full_path


def make_executable(path):
    if platform.system() == 'Windows':
        # Add a .bat extension to the file
        new_file_name = path + '.bat'
        os.rename(path, new_file_name)
        path = new_file_name
    else:
        # Make the file executable
        os.chmod(path, 0o755)
    return path


def download_from_pr(owner, repo, pr_number):

    # Metadata for the GitHub API
    headers = {'Authorization': f'token {TOKEN}'}
    download_name=f'djinni-generator-{pr_number}.zip'

    dbg_print(headers)

    # Get the commits for the pull request
    response = requests.get(f'https://api.github.com/repos/{owner}/{repo}/pulls/{pr_number}/commits', headers=headers)
    commits = response.json()
    dbg_print(commits)

    # Get the SHA of the last commit
    last_commit_sha = commits[-1]['sha']

    # Get the checks for the last commit
    response = requests.get(f'https://api.github.com/repos/{owner}/{repo}/commits/{last_commit_sha}/check-runs', headers=headers)
    checks = response.json()

    # Find the last successful check
    last_successful_check = None
    for check in checks['check_runs']:
        if check['status'] == 'completed' and check['conclusion'] == 'success':
            last_successful_check = check
            break

    if last_successful_check:
        # Extract the workflow run ID from the details URL
        match = re.search(r'/actions/runs/(\d+)', last_successful_check['details_url'])
        if match:
            run_id = match.group(1)
            # Get the list of artifacts for the workflow run
            response = requests.get(f'https://api.github.com/repos/{owner}/{repo}/actions/runs/{run_id}/artifacts', headers=headers)
            artifacts = response.json()

            if 'artifacts' in artifacts and artifacts['artifacts']:
                # Get the ID of the last artifact
                last_artifact_id = artifacts['artifacts'][0]['id']
                url = f'https://api.github.com/repos/{owner}/{repo}/actions/artifacts/{last_artifact_id}/zip'
                dl_file =  download_file(url, output_dir, download_name, headers=headers)

                with zipfile.ZipFile(dl_file, 'r') as zip_ref:
                    zip_ref.extractall(output_dir)
                file_name = zip_ref.namelist()[0]

                make_executable(os.path.join(output_dir,file_name))

            else:
                raise Exception('No artifacts found for this workflow run')
        else:
            raise Exception('Could not extract workflow run ID from details URL')
    else:
        raise Exception('No successful checks found')

def get_latest_release(owner, repo):
    response = requests.get(f'https://api.github.com/repos/{owner}/{repo}/releases/latest')
    response.raise_for_status()
    download_url = response.json()['assets'][0]['browser_download_url']
    dl_file = download_file(download_url, output_dir, 'djinni')
    make_executable(dl_file)

def get_latest_pre_release(owner, repo):
    response = requests.get(f'https://api.github.com/repos/{owner}/{repo}/releases')
    response.raise_for_status()
    for release in response.json():
        if release['prerelease']:
            download_url = release['assets'][0]['browser_download_url']
            print(download_url)
            dl_file = download_file(download_url, output_dir, 'djinni')
            make_executable(dl_file)
            break

# Get the argument, TODO, use argparse and add optional a folder argument
dl_arg = sys.argv[1]
if not dl_arg:
    sys.exit('No argument given')

owner = 'cross-language-cpp'
repo = 'djinni-generator'

try:
    if dl_arg.startswith("pr-"):
        print(f'Downloading from PR: {dl_arg}')
        pr_number = dl_arg[len("pr-"):]
        download_from_pr(owner, repo, pr_number)
    elif dl_arg == 'latest':
        print('Downloading latest')
        get_latest_pre_release(owner, repo)
    elif dl_arg == 'release':
        print('Downloading release')
        get_latest_release(owner, repo)
    else:
        raise Exception('Invalid argument given')
except Exception as e:
    print('Got Error:', e)
    traceback.print_exc()
    sys.exit(f'Error occurred: {e}')

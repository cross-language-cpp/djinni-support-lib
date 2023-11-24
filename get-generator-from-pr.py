import requests
import pprint
import re
import sys
import zipfile
import os
import platform

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


# For 'debugging' the JSON response
def dbg_print(data):
    print('------------------')
    pprint.pprint(data)
    print('------------------')


# Get the token from the environment variable
TOKEN_ENV_VAR='GENERATOR_DL_TOKEN'
TOKEN = os.getenv(TOKEN_ENV_VAR)
if TOKEN is None:
    sys.exit(f'{TOKEN_ENV_VAR} environment variable not set')

# Metadata for the GitHub API
headers = {'Authorization': f'token {TOKEN}'}
owner = 'cross-language-cpp'
repo = 'djinni-generator'
# Get the PR number from command line arguments
pr_number = sys.argv[1]
download_name=f'djinni-generator-{pr_number}.zip'

# Get the commits for the pull request
response = requests.get(f'https://api.github.com/repos/{owner}/{repo}/pulls/{pr_number}/commits', headers=headers)
commits = response.json()

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

            # Download the last artifact
            response = requests.get(f'https://api.github.com/repos/{owner}/{repo}/actions/artifacts/{last_artifact_id}/zip', headers=headers)

            # Save the artifact to a file
            with open(download_name, 'wb') as f:
                f.write(response.content)
            # Unzip the file
            with zipfile.ZipFile(download_name, 'r') as zip_ref:
                zip_ref.extractall('.')
            # Get the name of the file in the zip
            file_name = zip_ref.namelist()[0]
            # Check if the script is running on Windows
            if platform.system() == 'Windows':
                # Add a .bat extension to the file
                new_file_name = file_name + '.bat'
                os.rename(file_name, new_file_name)
                file_name = new_file_name
            else:
                # Make the file executable
                os.chmod(file_name, 0o755)
        else:
            print('No artifacts found for this workflow run')
    else:
        print('Could not extract workflow run ID from details URL')
else:
    print('No successful checks found')

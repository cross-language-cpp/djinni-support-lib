import setuptools

with open("README.md", "r", encoding="utf-8") as fh:
    long_description = fh.read()

setuptools.setup(
    name="djinni",
    version="1.2.1",
    author="Harald Achitz",
    author_email="harald.achitz@gmail.com",
    description="Python bindings for djinni",
    long_description=long_description,
    long_description_content_type="text/markdown",
    url="https://github.com/cross-language-cpp/djinni-support-lib",
    project_urls={
        "Bug Tracker": "https://github.com/cross-language-cpp/djinni-support-lib/issues",
    },
    classifiers=[
        "Programming Language :: Python :: 3",
        "License :: OSI Approved :: Apache Software License",
        "Operating System :: OS Independent",
    ],
    package_dir={"": "src"},
    packages=setuptools.find_packages(where="src"),    
    python_requires=">=3.7",
)

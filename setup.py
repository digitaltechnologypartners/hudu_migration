from setuptools import setup, find_packages

setup(
    name='Hudu_Migrator',
    version='0.1.0',
    packages=find_packages(),
    install_requires=[
        'Click',
    ],
    entry_points={
        'console_scripts': [
            'hudumig = hudumig.main:cli',
        ],
    },
)
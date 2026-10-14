from setuptools import setup, find_packages

setup(
    name="masters-vision",
    version="0.1.0",
    description="Indoor navigation system with computer vision",
    packages=find_packages(),
    python_requires=">=3.8",
    install_requires=[
        "opencv-python>=4.5.0",
        "numpy>=1.20.0",
        "torch>=1.9.0",
        "torchvision>=0.10.0",
        "scikit-image>=0.17.0",
        "matplotlib>=3.3.0",
        "pyyaml>=5.4.0",
    ],
    extras_require={
        "dev": [
            "pytest>=7.0.0",
            "pytest-cov>=3.0.0",
            "tqdm>=4.60.0",
            "loguru>=0.5.0",
        ],
    },
)
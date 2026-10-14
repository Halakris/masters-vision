import subprocess
import sys
import os
from setuptools import setup, find_packages


def ensure_venv():
    """Create virtual environment if it doesn't exist and return the path."""
    venv_path = os.path.join(os.path.dirname(os.path.abspath(__file__)), "venv")
    venv_python = os.path.join(venv_path, "bin", "python")
    if not os.path.exists(venv_python):
        print("Creating virtual environment...")
        subprocess.check_call([sys.executable, "-m", "virtualenv", venv_path])
    
    # Print activation instructions
    print(f"\nVirtual environment ready at: {venv_path}")
    print(f"To activate: source {os.path.join(venv_path, 'bin', 'activate')}")
    
    return venv_path


class VenvSetupCommand:
    """Custom setup command to ensure venv is created."""
    
    def run(self):
        venv_path = ensure_venv()
        print(f"\nVirtual environment at: {venv_path}")
        print("Remember to activate it before running the project:")


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
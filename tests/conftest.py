"""
Pytest 配置和全局 fixtures
"""
import pytest
import tempfile
import shutil
import subprocess
import json
from pathlib import Path
from typing import Dict, Any, Optional


@pytest.fixture(scope="session")
def test_fixtures_dir() -> Path:
    """返回测试 fixtures 目录"""
    return Path(__file__).parent / "fixtures"


@pytest.fixture(scope="session")
def scripts_dir(test_fixtures_dir: Path) -> Path:
    """返回 harness_skill scripts 目录"""
    return Path(__file__).parent.parent / "scripts"


@pytest.fixture
def temp_project_dir() -> Path:
    """
    创建临时项目目录，测试后自动清理

    Usage:
        def test_something(temp_project_dir):
            project_dir = temp_project_dir
            # 在临时目录执行测试
    """
    dir = Path(tempfile.mkdtemp(prefix="harness_test_"))
    yield dir
    shutil.rmtree(dir, ignore_errors=True)


@pytest.fixture
def sample_project_config() -> Dict[str, Any]:
    """返回示例项目配置"""
    return {
        "github": {
            "user": "testuser",
            "repo": "test-repo",
            "url": "https://github.com/testuser/test-repo",
            "token": ""
        },
        "project": {
            "name": "test-repo",
            "description": "测试项目",
            "default_branch": "main"
        }
    }


@pytest.fixture
def init_sample_project(temp_project_dir: Path, sample_project_config: Dict[str, Any]) -> Path:
    """
    初始化一个示例项目（包含基本配置文件和目录结构）

    Usage:
        def test_something(init_sample_project):
            project_dir = init_sample_project
    """
    # 创建 config 目录和配置文件
    config_dir = temp_project_dir / "config"
    config_dir.mkdir()

    # 写入 project.json
    with open(config_dir / "project.json", "w") as f:
        json.dump(sample_project_config, f, indent=2)

    # 创建基本目录结构
    (temp_project_dir / "docs" / "plans").mkdir(parents=True)
    (temp_project_dir / "docs" / "decisions").mkdir(parents=True)
    (temp_project_dir / "src").mkdir()
    (temp_project_dir / "tests").mkdir()

    # 初始化 git 仓库
    subprocess.run(["git", "init"], cwd=temp_project_dir, check=True, capture_output=True)
    subprocess.run(["git", "config", "user.name", "Test User"], cwd=temp_project_dir, check=True, capture_output=True)
    subprocess.run(["git", "config", "user.email", "test@example.com"], cwd=temp_project_dir, check=True, capture_output=True)
    subprocess.run(["git", "branch", "-M", "main"], cwd=temp_project_dir, check=True, capture_output=True)

    return temp_project_dir


@pytest.fixture
def scripts_dir_path() -> Path:
    """返回 harness_skill scripts 目录路径"""
    return Path(__file__).parent.parent / "scripts"


@pytest.fixture
def git_commit_script(scripts_dir_path: Path) -> Path:
    """返回 git_commit.sh 脚本路径"""
    return scripts_dir_path / "git_commit.sh"


@pytest.fixture
def guide_script(scripts_dir_path: Path) -> Path:
    """返回 guide.sh 脚本路径"""
    return scripts_dir_path / "guide.sh"


@pytest.fixture
def init_project_script(scripts_dir_path: Path) -> Path:
    """返回 init_project.sh 脚本路径"""
    return scripts_dir_path / "init_project.sh"


class ScriptRunner:
    """运行 bash 脚本的工具类"""

    @staticmethod
    def run(script_path: Path, args: Optional[list] = None,
            cwd: Optional[Path] = None, input_data: Optional[str] = None) -> subprocess.CompletedProcess:
        """
        运行 bash 脚本

        Args:
            script_path: 脚本路径
            args: 脚本参数
            cwd: 工作目录
            input_data: 标准输入数据

        Returns:
            subprocess.CompletedProcess 对象
        """
        cmd = ["bash", str(script_path)]
        if args:
            cmd.extend(args)

        return subprocess.run(
            cmd,
            cwd=cwd,
            input=input_data,
            capture_output=True,
            text=True,
            env={**dict(__import__("os").environ), "PROJECT_ROOT": str(cwd)} if cwd else None
        )


@pytest.fixture
def script_runner():
    """返回 ScriptRunner 工具类"""
    return ScriptRunner
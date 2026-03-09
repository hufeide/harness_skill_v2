"""
项目初始化工作流集成测试
"""
import pytest
import json
import subprocess
from pathlib import Path


@pytest.mark.integration
class TestInitWorkflow:
    """测试项目初始化工作流"""

    def test_full_initialization(self, temp_project_dir, init_project_script):
        """测试完整的项目初始化流程"""
        # 设置环境变量
        env = {
            "GITHUB_USER": "testuser",
            "PROJECT_NAME": "test-repo",
            "PROJECT_DESC": "测试项目描述"
        }

        # 运行初始化脚本（非交互式，使用环境变量）
        result = subprocess.run(
            ["bash", str(init_project_script)],
            cwd=temp_project_dir,
            capture_output=True,
            text=True,
            env={**dict(__import__("os").environ), **env}
        )

        # 验证配置文件创建
        assert (temp_project_dir / "config" / "project.json").exists()
        assert (temp_project_dir / "config" / "permissions.json").exists()
        assert (temp_project_dir / "config" / "env.json").exists()

        # 验证目录结构
        assert (temp_project_dir / "docs" / "plans").exists()
        assert (temp_project_dir / "docs" / "decisions").exists()
        assert (temp_project_dir / "src").exists()
        assert (temp_project_dir / "tests").exists()

        # 验证 Git 仓库
        assert (temp_project_dir / ".git").exists()

    def test_initialization_with_existing_git(self, init_sample_project, init_project_script):
        """测试在已有 Git 仓库中初始化"""
        # 项目已经由 init_sample_project fixture 初始化

        # 验证 Git 配置仍然存在
        result = subprocess.run(
            ["git", "remote", "get-url", "origin"],
            cwd=init_sample_project,
            capture_output=True,
            text=True
        )
        assert result.returncode == 0
        assert "test-repo" in result.stdout

    def test_project_config_content(self, temp_project_dir, init_project_script):
        """测试 project.json 内容"""
        env = {
            "GITHUB_USER": "hufeide",
            "PROJECT_NAME": "myproject",
            "PROJECT_DESC": "我的项目描述"
        }

        subprocess.run(
            ["bash", str(init_project_script)],
            cwd=temp_project_dir,
            capture_output=True,
            text=True,
            env={**dict(__import__("os").environ), **env}
        )

        config_path = temp_project_dir / "config" / "project.json"
        with open(config_path) as f:
            config = json.load(f)

        assert config["github"]["user"] == "hufeide"
        assert config["github"]["repo"] == "myproject"
        assert config["project"]["description"] == "我的项目描述"
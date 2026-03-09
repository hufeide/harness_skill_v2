"""
测试项目构建器
用于创建和管理测试项目
"""
import subprocess
import json
from pathlib import Path
from typing import Optional, Dict, Any


class ProjectBuilder:
    """构建测试项目的工具类"""

    @staticmethod
    def create_empty_project(
        project_dir: Path,
        github_user: str = "testuser",
        repo_name: str = "test-repo",
        repo_desc: str = "测试项目"
    ) -> Path:
        """
        创建一个空的测试项目目录

        Args:
            project_dir: 项目目录路径
            github_user: GitHub 用户名
            repo_name: 仓库名称
            repo_desc: 仓库描述

        Returns:
            项目目录 Path 对象
        """
        project_dir.mkdir(parents=True, exist_ok=True)

        # 创建 config 目录和配置文件
        config_dir = project_dir / "config"
        config_dir.mkdir()

        # 创建 project.json
        project_config = {
            "github": {
                "user": github_user,
                "repo": repo_name,
                "url": f"https://github.com/{github_user}/{repo_name}",
                "token": ""
            },
            "project": {
                "name": repo_name,
                "description": repo_desc,
                "default_branch": "main"
            }
        }

        with open(config_dir / "project.json", "w") as f:
            json.dump(project_config, f, indent=2, ensure_ascii=False)

        # 创建基本目录结构
        (project_dir / "docs" / "plans").mkdir(parents=True)
        (project_dir / "docs" / "decisions").mkdir(parents=True)
        (project_dir / "src").mkdir()
        (project_dir / "tests").mkdir()

        return project_dir

    @staticmethod
    def init_git_repo(
        project_dir: Path,
        user_name: str = "Test User",
        user_email: str = "test@example.com",
        branch_name: str = "main"
    ) -> bool:
        """
        初始化 Git 仓库

        Args:
            project_dir: 项目目录
            user_name: Git 用户名
            user_email: Git 用户邮箱
            branch_name: 主分支名称

        Returns:
            是否成功
        """
        try:
            subprocess.run(["git", "init"], cwd=project_dir, check=True, capture_output=True)
            subprocess.run(["git", "config", "user.name", user_name], cwd=project_dir, check=True, capture_output=True)
            subprocess.run(["git", "config", "user.email", user_email], cwd=project_dir, check=True, capture_output=True)
            subprocess.run(["git", "branch", "-M", branch_name], cwd=project_dir, check=True, capture_output=True)
            return True
        except subprocess.CalledProcessError:
            return False

    @staticmethod
    def add_file(project_dir: Path, relative_path: str, content: str = "test content") -> Path:
        """
        在项目目录中添加文件

        Args:
            project_dir: 项目目录
            relative_path: 相对于项目目录的路径
            content: 文件内容

        Returns:
            创建的文件 Path 对象
        """
        file_path = project_dir / relative_path
        file_path.parent.mkdir(parents=True, exist_ok=True)
        file_path.write_text(content)
        return file_path

    @staticmethod
    def create_sample_project(
        project_dir: Path,
        with_git: bool = True,
        github_user: str = "testuser",
        repo_name: str = "test-repo"
    ) -> Path:
        """
        创建完整的示例项目（包含配置文件和 Git 仓库）

        Args:
            project_dir: 项目目录
            with_git: 是否初始化 Git 仓库
            github_user: GitHub 用户名
            repo_name: 仓库名称

        Returns:
            项目目录 Path 对象
        """
        # 创建基本项目结构
        ProjectBuilder.create_empty_project(project_dir, github_user, repo_name)

        # 添加一些示例文件
        ProjectBuilder.add_file(project_dir, "README.md", "# Test Project\n\n测试项目描述")
        ProjectBuilder.add_file(project_dir, ".gitignore", "node_modules/\n*.log\n.env")
        ProjectBuilder.add_file(project_dir, "src/main.py", "# 主文件\nprint('Hello, World!')")

        # 初始化 Git 仓库
        if with_git:
            ProjectBuilder.init_git_repo(project_dir)

        return project_dir
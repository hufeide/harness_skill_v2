"""
配置文件测试
"""
import json
import pytest
from pathlib import Path


class TestProjectConfig:
    """测试 project.json 配置"""

    def test_valid_project_config(self, temp_project_dir):
        """测试有效的 project.json 配置"""
        config = {
            "github": {
                "user": "hufeide",
                "repo": "test4",
                "url": "https://github.com/hufeide/test4",
                "token": ""
            },
            "project": {
                "name": "test4",
                "description": "测试项目",
                "default_branch": "main"
            }
        }

        config_dir = temp_project_dir / "config"
        config_dir.mkdir()
        config_path = config_dir / "project.json"

        with open(config_path, "w") as f:
            json.dump(config, f, indent=2)

        # 验证配置
        with open(config_path) as f:
            loaded_config = json.load(f)

        assert loaded_config["github"]["user"] == "hufeide"
        assert loaded_config["github"]["repo"] == "test4"
        assert loaded_config["project"]["name"] == "test4"

    def test_missing_github_section(self, temp_project_dir):
        """测试缺少 github 部分的配置"""
        config = {
            "project": {
                "name": "test4"
            }
        }

        config_dir = temp_project_dir / "config"
        config_dir.mkdir()
        config_path = config_dir / "project.json"

        with open(config_path, "w") as f:
            json.dump(config, f)

        with open(config_path) as f:
            loaded_config = json.load(f)

        assert "github" not in loaded_config

    def test_empty_github_token(self, temp_project_dir):
        """测试空的 GitHub token"""
        config = {
            "github": {
                "user": "hufeide",
                "repo": "test4",
                "url": "https://github.com/hufeide/test4",
                "token": ""
            }
        }

        config_dir = temp_project_dir / "config"
        config_dir.mkdir()
        config_path = config_dir / "project.json"

        with open(config_path, "w") as f:
            json.dump(config, f)

        with open(config_path) as f:
            loaded_config = json.load(f)

        assert loaded_config["github"]["token"] == ""


class TestPermissionsConfig:
    """测试 permissions.json 配置"""

    def test_valid_permissions_config(self, temp_project_dir):
        """测试有效的 permissions.json 配置"""
        config = {
            "permissions": {
                "allow": ["Bash:*", "Filesystem:*", "Git:*"],
                "deny": ["Bash:rm", "Bash:rm -rf"]
            },
            "Bash": {
                "allowAll": True,
                "denyCommands": ["rm", "rm -rf"]
            }
        }

        config_dir = temp_project_dir / "config"
        config_dir.mkdir()
        config_path = config_dir / "permissions.json"

        with open(config_path, "w") as f:
            json.dump(config, f, indent=2)

        assert config_path.exists()


class TestEnvConfig:
    """测试 env.json 配置"""

    def test_valid_env_config(self, temp_project_dir):
        """测试有效的 env.json 配置"""
        config = {
            "PROJECT_NAME": "test4",
            "PROJECT_DESCRIPTION": "测试项目",
            "DATABASE_URL": "mongodb://localhost:27017/mydb",
            "MODEL": "claude-v1"
        }

        config_dir = temp_project_dir / "config"
        config_dir.mkdir()
        config_path = config_dir / "env.json"

        with open(config_path, "w") as f:
            json.dump(config, f, indent=2)

        with open(config_path) as f:
            loaded_config = json.load(f)

        assert loaded_config["PROJECT_NAME"] == "test4"
        assert loaded_config["MODEL"] == "claude-v1"
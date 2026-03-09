#!/bin/bash

# 创建源代码文件脚本
# 用法：
#   ./create_source_file.sh <type> <filename> [content]
#   ./create_source_file.sh html index "HTML 内容"
#   ./create_source_file.sh css styles "CSS 内容"
#   ./create_source_file.sh js app "JavaScript 内容"

set -e

PROJECT_ROOT="$(pwd)"
SRC_DIR="$PROJECT_ROOT/src"

# 颜色
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

# 获取参数
FILE_TYPE="$1"
FILE_NAME="$2"

# 验证参数
if [ -z "$FILE_TYPE" ] || [ -z "$FILE_NAME" ]; then
    echo "错误：请提供文件类型和文件名"
    echo "用法：$0 <type> <filename> [content]"
    echo ""
    echo "可用类型："
    echo "  html  - HTML 文件 (放到 src/html/)"
    echo "  css   - CSS 文件 (放到 src/css/)"
    echo "  js    - JavaScript 文件 (放到 src/js/)"
    echo "  images - 图片文件 (放到 src/images/)"
    exit 1
fi

# 根据类型确定目录和扩展名
case "$FILE_TYPE" in
    "html")
        TARGET_DIR="$SRC_DIR/html"
        EXT="html"
        ;;
    "css")
        TARGET_DIR="$SRC_DIR/css"
        EXT="css"
        ;;
    "js")
        TARGET_DIR="$SRC_DIR/js"
        EXT="js"
        ;;
    "images")
        TARGET_DIR="$SRC_DIR/images"
        EXT=""
        ;;
    *)
        echo "错误：未知的文件类型 '$FILE_TYPE'"
        echo "可用类型：html, css, js, images"
        exit 1
        ;;
esac

# 创建目录
mkdir -p "$TARGET_DIR"

# 完整文件名
FULL_FILE_NAME="$FILE_NAME.$EXT"
FULL_PATH="$TARGET_DIR/$FULL_FILE_NAME"

# 创建文件
if [ -n "$3" ]; then
    echo "$3" > "$FULL_PATH"
else
    # 如果没有内容，创建占位符文件
    touch "$FULL_PATH"
fi

echo ""
echo -e "${GREEN}✓ 已创建文件${NC}"
echo -e "${BLUE}  路径：$FULL_PATH${NC}"
echo ""

# 更新状态
if [ -f "$PROJECT_ROOT/.guide_state" ]; then
    bash "$(dirname "$0")/update_state.sh" update development "创建 $FILE_TYPE 文件：$FILE_NAME"
fi
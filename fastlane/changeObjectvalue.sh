#!/bin/zsh

# 파일 경로
FILE_PATH="../Projects/App/iOS/MyMandalart.xcodeproj/project.pbxproj"

# 변경할 기존 값과 새 값 설정
OLD_VALUE="objectVersion = [0-9]\+;"
NEW_VALUE="objectVersion = 60;"

# 파일에서 OLD_VALUE를 NEW_VALUE로 변경
if [[ -f "$FILE_PATH" ]]; then
  sed -i '' "s/${OLD_VALUE}/${NEW_VALUE}/g" "$FILE_PATH"
  echo "'${OLD_VALUE}'를 '${NEW_VALUE}'로 변경했습니다."
else
  echo "파일을 찾을 수 없습니다: $FILE_PATH"
fi

#!/bin/bash

# 사용법:
# 1) repos.txt 에 클론할 레포 주소들을 한 줄에 하나씩 넣어둔다.
#    예: 
#    https://github.com/tj/commander.js
#    https://github.com/expressjs/express
#
# 2) ./git_clone_batch.sh repos.txt

if [ -z "$1" ]; then
  echo "사용법: $0 <repos.txt>"
  exit 1
fi

INPUT_FILE="$1"
BASE_DIR="../datasets/"

# datasets 디렉터리 없으면 생성
mkdir -p "$BASE_DIR"

while IFS= read -r REPO_URL; do
  # 빈 줄 무시
  [ -z "$REPO_URL" ] && continue

  # 레포 이름 추출 (예: commander.js, express)
  REPO_NAME=$(basename -s .git "$REPO_URL")

  # 대상 디렉터리 생성
  TARGET_DIR="${BASE_DIR}/${REPO_NAME}"
  mkdir -p "$TARGET_DIR"

  echo "클론 시작: $REPO_URL → $TARGET_DIR"

  # with-lock 클론
  git clone "$REPO_URL" "${TARGET_DIR}/with-lock"

  # no-lock 클론
  git clone "$REPO_URL" "${TARGET_DIR}/no-lock"

  # no-lock에서 package-lock.json 삭제
  if [ -f "${TARGET_DIR}/no-lock/package-lock.json" ]; then
    rm "${TARGET_DIR}/no-lock/package-lock.json"
    echo "package-lock.json 삭제 완료: ${TARGET_DIR}/no-lock"
  else
    echo "package-lock.json 없음: ${TARGET_DIR}/no-lock"
  fi

  echo "완료: ${TARGET_DIR}/with-lock , ${TARGET_DIR}/no-lock"

done < "$INPUT_FILE"

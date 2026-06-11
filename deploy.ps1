# =========================================================
#  태국 한인 선교 70주년 기념 사이트 — GitHub Pages 배포 스크립트
#  실행 방법: PowerShell 에서  .\deploy.ps1
# =========================================================

$ErrorActionPreference = "Stop"
$deploy = Split-Path -Parent $MyInvocation.MyCommand.Path

Write-Host ""
Write-Host "=======================================" -ForegroundColor Cyan
Write-Host "  태국 한인 선교 70주년 — GitHub 배포" -ForegroundColor Cyan
Write-Host "=======================================" -ForegroundColor Cyan

# ── 1. GitHub CLI 로그인 확인 ─────────────────────────────
Write-Host "`n[1/5] GitHub 로그인 확인..." -ForegroundColor Yellow
$authStatus = gh auth status 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Host "  GitHub 로그인이 필요합니다." -ForegroundColor Red
    Write-Host "  지금 로그인을 시작합니다 (브라우저가 열립니다)..." -ForegroundColor Yellow
    gh auth login --hostname github.com --git-protocol https --web
}
Write-Host "  로그인 확인 완료" -ForegroundColor Green

# ── 2. git 초기화 ────────────────────────────────────────
Write-Host "`n[2/5] git 저장소 초기화..." -ForegroundColor Yellow
Set-Location $deploy

if (Test-Path ".git") {
    Write-Host "  기존 .git 폴더 제거 후 재초기화" -ForegroundColor DarkGray
    Remove-Item ".git" -Recurse -Force
}
git init
git config user.email "backhung65@gmail.com"
git config user.name "Baekhyungjin"
Write-Host "  완료" -ForegroundColor Green

# ── 3. 파일 스테이징 ─────────────────────────────────────
Write-Host "`n[3/5] 파일 추가 중..." -ForegroundColor Yellow
git add .
$fileCount = (git ls-files | Measure-Object -Line).Lines
Write-Host "  $fileCount 개 파일 스테이징 완료" -ForegroundColor Green

# ── 4. 커밋 ─────────────────────────────────────────────
Write-Host "`n[4/5] 커밋..." -ForegroundColor Yellow
git commit -m "태국 한인 선교 70주년 기념 사이트 (1956-2026)"
Write-Host "  완료" -ForegroundColor Green

# ── 5. GitHub 저장소 생성 및 푸시 ─────────────────────────
Write-Host "`n[5/5] GitHub 저장소 생성 및 배포..." -ForegroundColor Yellow

# 기존 저장소가 있으면 삭제 후 재생성 (오류 무시)
gh repo delete thailand-mission-70th --yes 2>$null

gh repo create thailand-mission-70th `
    --public `
    --description "태국 한인 선교 70주년 기념 (1956-2026) | 50th Anniversary of Korean Mission in Thailand" `
    --source=. `
    --push

Write-Host "  저장소 생성 및 push 완료" -ForegroundColor Green

# ── GitHub Pages 활성화 ──────────────────────────────────
Write-Host "`n[+] GitHub Pages 활성화 중..." -ForegroundColor Yellow
Start-Sleep -Seconds 5
gh api "repos/Baekhyungjin/thailand-mission-70th/pages" `
    --method POST `
    -f "source[branch]=main" `
    -f "source[path]=/" 2>$null

Write-Host ""
Write-Host "=======================================" -ForegroundColor Green
Write-Host "  배포 완료!" -ForegroundColor Green
Write-Host "=======================================" -ForegroundColor Green
Write-Host ""
Write-Host "  GitHub 저장소:" -NoNewline
Write-Host " https://github.com/Baekhyungjin/thailand-mission-70th" -ForegroundColor Cyan
Write-Host ""
Write-Host "  공개 사이트 (1~2분 후 활성화):" -NoNewline
Write-Host " https://baekhyungjin.github.io/thailand-mission-70th/" -ForegroundColor Cyan
Write-Host ""
Write-Host "  ※ 큰 영상 파일(96MB짜리 2개)은 용량 초과로 제외되었습니다." -ForegroundColor DarkGray
Write-Host "    로컬에서만 재생 가능합니다." -ForegroundColor DarkGray
Write-Host ""

---
description: 격리된 AI Council Plan 모드. 3인 plan → 통합 → contrarian 반박 → skeptic·validator 검증 → 개발 문서.
argument-hint: <분석할 요구사항/기능>
allowed-tools: Agent
---

사용자 요구사항: $ARGUMENTS

## 단 하나의 일

`council-plan-orchestrator` 에이전트를 **딱 한 번** 호출하고, 받은 결과(개발 문서)를 **그대로** 사용자에게 보여주세요.

호출 prompt에 포함:
- 사용자 요구사항 (`$ARGUMENTS`) 그대로
- 프로젝트 루트 (현재 작업 디렉터리)
- 안내 문구: "이 호출은 격리된 council-plan 실행입니다. 이전 council/plan 호출 결과를 알 필요 없습니다. 모든 단계 prompt를 처음부터 새로 작성하세요."

## 절대 하지 말 것

- 위원·merger·doc-writer를 직접 호출 금지. **모든 오케스트레이션은 orchestrator의 일.**
- orchestrator의 출력을 요약·재포맷·코멘트 금지. 그대로 전달.
- 부모 세션의 이전 흔적이 새 호출에 새지 않도록 위임 원칙을 깨지 마세요.

## 비용 안내

이 명령은 3인 plan + merger + contrarian + 검증 2인 + doc-writer + orchestrator = **9개 에이전트 호출**입니다 (대부분 Opus). `--lite` 명시 시에만 sonnet으로 다운그레이드 지시.

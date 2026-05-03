---
description: 격리된 7인 AI Council (5인 위원 → 2인 Rebuttal → Synthesizer). yes-man 편향 회피 + 부모 세션 컨텍스트 격리.
argument-hint: <분석할 질문/결정>
allowed-tools: Agent
---

사용자 질문: $ARGUMENTS

## 단 하나의 일

`council-orchestrator` 에이전트를 **딱 한 번** 호출하고, 받은 결과를 **그대로** 사용자에게 보여주세요.

호출 prompt에 포함:
- 사용자 질문 (`$ARGUMENTS`) 그대로
- 프로젝트 루트 (현재 작업 디렉터리)
- 안내 문구: "이 호출은 격리된 council 실행입니다. 이전 council 호출 결과를 알 필요·참조할 필요 없습니다. 모든 위원·Rebuttal·Synthesizer prompt는 처음부터 새로 작성하세요."

## 절대 하지 말 것

- 위원·Rebuttal·Synthesizer를 **직접 호출 금지**. 모든 오케스트레이션은 orchestrator의 일.
- orchestrator의 출력을 요약·재포맷·코멘트 금지. 그대로 전달.
- 부모 세션(=현재 컨텍스트)의 이전 council 흔적이 새 호출에 새지 않도록, 위 위임 원칙을 깨지 마세요. **이 위임이 격리의 핵심**입니다.

## 비용 안내

이 명령은 1단계 5명 + 2단계 2명 + 3단계 1명 + orchestrator 1명 = **9개 에이전트 호출**입니다 (대부분 Opus). 사용자가 `--lite` 명시 시에만 모든 모델을 sonnet으로 다운그레이드 지시.

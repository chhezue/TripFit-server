# 여행방 참여 플로우

> NotebookLM 기획 자료 정리본.

- **목적:** 초대받은 참여자가 여행방에 입장하고 일정을 처음 제출함
- **액터:** 참여자
- **사전 조건:** 방장으로부터 공유받은 초대 링크 또는 참여 코드

**단계:**

1. 초대 링크 클릭 또는 참여 코드 입력
2. 앱 설치 여부 분기 → 앱 실행 또는 웹 랜딩 (BR-USER-002)
3. 소셜 로그인 (필수, 비회원 없음 — BR-USER-002)
4. `isScheduleRegistered=false`이면 `schedule` CONDITION 입력 (BR-USER-006)
5. (기존 사용자) CONDITION·AVAILABILITY 확인·수정 (BR-USER-008)
6. trip 희망 기간 내 AVAILABILITY 입력 (BR-TRIP-002, BR-TRIP-003)
7. 「일정 제출하기」 클릭 (BR-USER-007)

**성공 종료 조건:** `trip_member.status=RESPONDED` 및 여행방 상세 진입

**예외 / 분기:**

- 일정 제출 없이 이탈 → 참여 완료 미인정 (BR-USER-007)
- 이미 확정된 여행방 → 안내 메시지
- 미로그인 → 로그인 유도

**MVP 포함 여부:** In

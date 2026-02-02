# ❄️ 2026 Milano-Cortina Winter Olympic Multi-watch System (v2.1)

Xilinx FPGA 환경에서 **MicroBlaze/RISC-V 소프트 프로세서**를 활용하여 구현한 동계 올림픽 특화 통합 제어 시스템입니다. 듀얼 I2C LCD와 전용 알람 IP를 연동하여 실제 경기 운영과 유사한 사용자 경험을 제공합니다.

---

## 🛠 Hardware Configuration

* **Target Board:** Digilent Basys 3 (Artix-7 FPGA)
* **Display:** * 1602 I2C LCD x 2 (Main Info / Lap Record)
    * 7-Segment Display (Real-time Clock/Timer)
* **Control:** 4-Way Buttons, 16-Way Switches
* **Custom IP (AXI4-Lite):**
    * `WINTER_ALARM`: **[NEW]** 경기 이벤트 알람 전용 제어 IP (1초 펄스 출력)
    * `WINTER_STOPWATCH`: 1/100초 단위 정밀 스톱워치
    * `WINTER_WATCH`: RTC 기반 세계 시계 (서울/밀라노)
    * `WINTER_COOKTIMER`: 경기/휴식 시간 관리용 카운트다운 타이머
    * `IIC_CNTR`: LCD 제어를 위한 I2C 컨트롤러

---

## 🚀 Key Features (Modes)

시스템은 스위치(`SW0~SW3`)를 통해 실시간으로 모드를 전환하며, 각 모드별로 최적화된 인터럽트 기반 사용자 인터페이스를 제공합니다.

### 1. 🕒 Digital Watch Mode (Seoul & Milan)
* **기능:** 서울과 밀라노(시차 8시간)의 시간을 동시 표시합니다.
* **로직:** 서울 시간 기준 **-8시간** 시차를 실시간 계산하여 출력합니다.
* **조작:** 버튼을 통해 시/분/초를 직접 설정하고 하드웨어 RTC에 동기화할 수 있습니다.

### 2. ⛸️ Speed Skating Mode
* **기능:** 4바퀴(Lap) 기록 측정 및 Personal Best(PB) 관리 시스템입니다.
* **Last Lap Alarm:** 3번째 바퀴를 지날 때(마지막 한 바퀴 전), **전용 알람(Buzzer)**이 울려 마지막 스퍼트를 안내합니다.
* **특징:** 최단 구간 기록(Best)을 실시간 갱신하여 상단 LCD에 고정 표시하며, 4바퀴 완료 시 자동 정지합니다.

### 3. ⛷️ Alpine Skiing Mode
* **기능:** 스톱워치 기능에 페널티 시스템을 결합한 경기용 모드입니다.
* **Penalty Alarm:** 기문 통과 실패 시 버튼(Btn3)으로 **+3초 페널티**를 부여하며, 이때 시각적/청각적 피드백을 위해 알람이 작동합니다.
* **표시:** LCD에 순수 측정 시간과 페널티가 합산된 최종 기록을 실시간 출력합니다.

### 4. 🏒 Ice Hockey Manager
* **기능:** 경기(Period), 작전 타임(Timeout), 휴식(Intermission) 상태를 관리하는 FSM 기반 모드입니다.
* **자동 전환:** 각 상태 종료 시 알람이 발생하며 다음 상태로 자동 전환됩니다. (예: 경기 종료 후 휴식 시간 자동 카운트다운)

---

## 🎮 How to Control

| Switch | Mode | Btn0 (1) | Btn1 (2) | Btn2 (4) | Btn3 (8) |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **SW0** | Watch | Hour ++ | Min ++ | Sec ++ | Time Reset |
| **SW1** | Speed Skating | Start/Stop | **Lap/Split** | Clear | - |
| **SW2** | Alpine Skiing | Start/Stop | Lap | Clear | **Penalty(+3s)** |
| **SW3** | Ice Hockey | Start/Pause | **Timeout** | Hard Reset | - |

---

## 📂 Project Structure

* **main.c**: 모드 전환 로직 및 인터럽트 핸들러 (GPIO, UART) 제어.
* **platform.h / .c**: Xilinx 하드웨어 추상화 계층.
* **LCD_Functions**: I2C LCD 제어 및 문자열 포맷팅 함수군.
* **Helper_Functions**: 각 경기별 특화 로직 (Split 계산, 시차 계산, 알람 제어 등).

---

## 💡 Technical Insights

* **Dedicated Alarm Control:** 전용 `alarm_device` 레지스터를 통해 1초 단위의 정밀한 알람 펄스(`alarm_pulse`)를 구현하여 사용자 피드백을 강화했습니다.
* **Interrupt-Driven IO:** GPIO(버튼/스위치) 및 UART 수신을 인터럽트 방식으로 처리하여 CPU 부하를 줄이고 루프 지연을 최소화했습니다.
* **Shared Memory Register Map:** 각 하드웨어 IP의 레지스터 주소를 직접 핸들링하여 저수준 제어 성능을 확보했습니다.
* **Modular LCD Update:** 화면 전체를 지우지 않고 필요한 부분(8칸 단위 등)만 갱신하여 LCD 데이터 병목 및 깜빡임 현상을 해결했습니다.

<img width="335" height="854" alt="image" src="https://github.com/user-attachments/assets/257afa18-c34a-4976-8c32-9c16ee72a9c1" />
<img width="875" height="855" alt="image" src="https://github.com/user-attachments/assets/26ea42fc-1235-45cb-9a71-60a9a61c962d" />



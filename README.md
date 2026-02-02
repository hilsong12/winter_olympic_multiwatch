# ❄️ 2026 Milano-Cortina Winter Olympic Multi-watch System

Xilinx FPGA 환경에서 **MicroBlaze/RISC-V 소프트 프로세서**를 활용하여 구현한 동계 올림픽 특화 통합 제어 시스템입니다. 듀얼 I2C LCD와 FND, 버튼/스위치를 통해 4가지 경기 모드를 지원합니다.

---

## 🛠 Hardware Configuration

* **Target Board:** Digilent Basys 3 (Artix-7 FPGA)
* **Display:** * 1602 I2C LCD x 2 (Main Info / Lap Record)
    * 7-Segment Display (Real-time Clock/Timer)
* **Control:** 4-Way Buttons, 16-Way Switches
* **Custom IP (AXI4-Lite):**
    * `WINTER_STOPWATCH`: 1/100초 단위 정밀 스톱워치
    * `WINTER_WATCH`: RTC 기반 세계 시계 (서울/밀라노)
    * `WINTER_COOKTIMER`: 경기/휴식 시간 관리용 카운트다운 타이머
    * `IIC_CNTR`: LCD 제어를 위한 I2C 컨트롤러
    * `FND_CNTR`: 7-Segment 다중화 제어

---

## 🚀 Key Features (Modes)

시스템은 스위치(`SW0~SW3`)를 통해 실시간으로 모드를 전환하며, 각 모드별로 최적화된 인터럽트 기반 사용자 인터페이스를 제공합니다.

### 1. 🕒 Digital Watch Mode (Seoul & Milan)
* **기능:** 서울과 밀라노(시차 8시간)의 시간을 동시 표시합니다.
* **조작:** 버튼을 통해 시/분/초를 직접 설정하고 하드웨어 RTC에 동기화할 수 있습니다.
* **FND:** 현재 시간(HH:MM)을 실시간으로 출력합니다.

### 2. ⛸️ Speed Skating Mode
* **기능:** 4바퀴(Lap) 기록 측정 및 **Personal Best(PB)** 관리 시스템입니다.
* **특징:** * 각 랩 타임 측정 시 Split Time(구간 기록) 자동 계산.
    * 최단 구간 기록(Best)을 실시간 갱신하여 상단 LCD에 고정 표시.
    * 4바퀴 완료 시 자동 정지 및 알람 펄스 발생.

### 3. ⛷️ Alpine Skiing Mode
* **기능:** 스톱워치 기능에 페널티 시스템을 결합한 경기용 모드입니다.
* **조작:** 기문 통과 실패 등 발생 시 버튼(Btn3)을 눌러 즉시 **+3초 페널티**를 부여합니다.
* **표시:** LCD에 순수 측정 시간과 페널티가 합산된 최종 기록을 실시간 출력합니다.

### 4. 🏒 Ice Hockey Manager
* **기능:** 복잡한 경기 시간 및 휴식/작전 시간을 관리하는 FSM(Finite State Machine) 기반 모드입니다.
* **상태 전이:** * `Period`: 20분 경기 (테스트 시 가속 설정 가능)
    * `Timeout`: 작전 타임(30초) 후 기존 경기 시간 복구
    * `Intermission`: 피리어드 사이 15분 휴식
* **자동화:** 각 상태 종료 시 알람이 발생하며 다음 상태로 자동 전환됩니다.

---

## 🎮 How to Control

| Switch | Mode | Btn0 | Btn1 | Btn2 | Btn3 |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **SW0** | Watch | Hour ++ | Min ++ | Sec ++ | Reset |
| **SW1** | Speed Skating | Start/Stop | **Lap** | Clear | - |
| **SW2** | Alpine Skiing | Start | Lap | Clear | **Penalty(+3s)** |
| **SW3** | Ice Hockey | Start/Pause | **Timeout** | Hard Reset | - |

---

## 📂 Project Structure

* **main.c**: 모드 전환 로직 및 인터럽트 핸들러 (GPIO, UART) 제어.
* **platform.h / .c**: Xilinx 하드웨어 추상화 계층.
* **LCD_Functions**: I2C LCD 제어 및 문자열 포맷팅 함수군.
* **Helper_Functions**: 각 경기별 특화 로직 (Split 계산, 시차 계산 등).

---

## 💡 Technical Insights

* **Interrupt-Driven IO**: GPIO(버튼/스위치) 및 UART 수신을 인터럽트 방식으로 처리하여 CPU 부하를 줄이고 루프 지연을 최소화했습니다.
* **Shared Memory Register Map**: 각 하드웨어 IP의 레지스터 주소를 직접 핸들링하여 저수준 제어 성능을 확보했습니다.
* **Modular LCD Update**: 화면 전체를 지우지 않고 필요한 부분(8칸 단위 등)만 갱신하여 LCD 데이터 병목 및 깜빡임 현상을 해결했습니다.

<img width="335" height="854" alt="image" src="https://github.com/user-attachments/assets/257afa18-c34a-4976-8c32-9c16ee72a9c1" />
<img width="875" height="855" alt="image" src="https://github.com/user-attachments/assets/26ea42fc-1235-45cb-9a71-60a9a61c962d" />



#include <stdio.h>
#include <stdint.h>

enum registers {
        IP = 0xFF,
        IN = 0xFE,
        OT = 0xFD,
        RS = 0xFC,
        R0 = 0xFB,
        R1 = 0xFA,
        RN = 0xF9,
        EX = 0xF8
};

int main(int argc, char **argv) {
        FILE *fp;
        uint8_t memory[0x100] = {0};

        if(argc != 2) {
                printf("Usage: %s <input variable>\n", argv[0]);
                return 1;
        }

        fp = fopen(argv[1], "r");
        if(!fp) {
                printf("Could not open %s.\n", argv[1]);
                return 2;
        }
        fread(memory, 1, 0x100, fp);
        fclose(fp);

        while(getchar() != '\n');

        while(1) {
                switch(memory[memory[IP]]) {
                case RN:
                case R1:
                case R0:
                case IN: break;
                case OT:
                        switch(memory[memory[IP]+1]) {
                        case IN: putchar(getchar()); break;
                        case R0: putchar(0); break;
                        case R1: putchar(1); break;
                        case RN: putchar(IP); break;
                        case OT: break;
                        case EX: break;
                        default: putchar(memory[memory[memory[IP]+1]]); break;
                        } break;
                case EX: return 0;
                default:
                        switch(memory[memory[IP]+1]) {
                        case IN: memory[memory[memory[IP]]] += getchar(); break;
                        case R0: break;
                        case R1: memory[memory[memory[IP]]] += 1; break;
                        case RN: memory[memory[memory[IP]]] -= 1; break;
                        case OT: break;
                        case EX: break;
                        default: memory[memory[memory[IP]]] += memory[memory[memory[IP]+1]]; break;
                        } break;
                }
                memory[IP] += 2;
        }
}

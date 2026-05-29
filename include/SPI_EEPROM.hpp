#pragma once

#include <cstdint>

// Comandos para memoria EEPROM 25AA
namespace EEPROM_Commands {
    constexpr uint8_t READ  = 0b00000011;  // Leer datos del array de memoria
    constexpr uint8_t WRITE = 0b00000010;  // Escribir datos en el array de memoria
    constexpr uint8_t WRDI  = 0b00000100;  // Reset write enable latch
    constexpr uint8_t WREN  = 0b00000110;  // Set write enable latch
    constexpr uint8_t RDSR  = 0b00000101;  // Leer STATUS register
    constexpr uint8_t WRSR  = 0b00000001;  // Escribir STATUS register
}

// Configuración SPI
struct SPIConfig {
    const char* device = "/dev/spidev0.0";
    uint32_t speed_hz = 1000000;   // 1 MHz
    uint8_t bits_per_word = 8;
    uint8_t mode = 0;               // SPI_MODE_0
    uint16_t delay_us = 0;
};

// Tamaños de buffer
constexpr int MAX_BUFFER_SIZE = 255;
constexpr int COMMAND_SIZE = 3;

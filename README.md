# SPI EEPROM 25AA para Raspberry Pi

[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![C++](https://img.shields.io/badge/C%2B%2B-17-blue.svg)](https://isocpp.org/)
[![Platform](https://img.shields.io/badge/platform-Raspberry%20Pi-green.svg)](https://www.raspberrypi.org/)

## 📋 Descripción

Este proyecto proporciona una implementación completa y profesional para comunicarse con memorias EEPROM de la serie 25AA (como 25AA256, 25AA512, etc.) utilizando el bus SPI en Raspberry Pi.

El código está optimizado para ser:
- **Robusto**: Manejo completo de errores
- **Modular**: Fácil de integrar en otros proyectos
- **Documentado**: Código comentado y explicado
- **Profesional**: Estructura de proyecto estándar

## 📁 Estructura del Proyecto



Raspberry Pi                    EEPROM 25AA
    ┌─────────┐                 ┌─────────┐
    │  3.3V   ├─────────────────┤ VCC (8) │
    │  GND    ├─────────────────┤ VSS (7) │
    │  GPIO8  ├─────────────────┤ CS  (1) │
    │  GPIO11 ├─────────────────┤ SCK (2) │
    │  GPIO10 ├─────────────────┤ MOSI(3) │
    │  GPIO9  ├─────────────────┤ MISO(4) │
    └─────────┘                 └─────────┘



    #include "SPI_EEPROM.hpp"

int main() {
    // Configurar SPI
    SPIConfig config;
    config.speed_hz = 1000000;  // 1 MHz

    // Abrir dispositivo
    int fd = open(config.device, O_RDWR);

    // Configurar SPI
    ioctl(fd, SPI_IOC_WR_MODE, &config.mode);
    ioctl(fd, SPI_IOC_WR_MAX_SPEED_HZ, &config.speed_hz);

    // Leer datos de dirección 0xFC00
    uint8_t tx_buffer[3] = {READ, 0xFC, 0x00};
    uint8_t rx_buffer[3];

    struct spi_ioc_transfer spi = {};
    spi.tx_buf = (unsigned long)tx_buffer;
    spi.rx_buf = (unsigned long)rx_buffer;
    spi.len = 3;

    ioctl(fd, SPI_IOC_MESSAGE(1), &spi);

    // Mostrar datos
    printf("Datos: 0x%02X 0x%02X 0x%02X\n",
           rx_buffer[0], rx_buffer[1], rx_buffer[2]);

    close(fd);
    return 0;
}

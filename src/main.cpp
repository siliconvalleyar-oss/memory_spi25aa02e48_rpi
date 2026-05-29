#include <iostream>
#include <iomanip>
#include "main.hpp"
#include "SPI_EEPROM.hpp"

int main() {
    std::cout << "\n=== SPI EEPROM 25AA Test ===" << std::endl;
    std::cout << "============================\n" << std::endl;
    
    // Configuración SPI
    SPIConfig spi_config;
    spi_config.device = "/dev/spidev0.0";
    spi_config.speed_hz = 1000000;
    
    // Abrir dispositivo SPI
    int fd = open(spi_config.device, O_RDWR);
    if (fd < 0) {
        std::cerr << "Error: No se pudo abrir " << spi_config.device << std::endl;
        return 1;
    }
    
    std::cout << "✓ Dispositivo SPI abierto" << std::endl;
    
    // Configurar SPI
    int mode = spi_config.mode;
    int bits = spi_config.bits_per_word;
    int speed = spi_config.speed_hz;
    
    if (ioctl(fd, SPI_IOC_WR_MODE, &mode) < 0 ||
        ioctl(fd, SPI_IOC_WR_BITS_PER_WORD, &bits) < 0 ||
        ioctl(fd, SPI_IOC_WR_MAX_SPEED_HZ, &speed) < 0) {
        std::cerr << "Error configurando SPI" << std::endl;
        close(fd);
        return 1;
    }
    
    std::cout << "✓ SPI configurado: " << speed << " Hz" << std::endl;
    
    // Preparar buffers
    uint8_t tx_buffer[MAX_BUFFER_SIZE];
    uint8_t rx_buffer[MAX_BUFFER_SIZE];
    
    // Inicializar buffers
    for(int i = 0; i < MAX_BUFFER_SIZE; ++i) {
        rx_buffer[i] = 0xFF;
        tx_buffer[i] = 0xFF;
    }
    
    // Configurar transferencia SPI
    struct spi_ioc_transfer spi_transfer = {};
    spi_transfer.tx_buf = (unsigned long)tx_buffer;
    spi_transfer.rx_buf = (unsigned long)rx_buffer;
    spi_transfer.len = 3;
    spi_transfer.speed_hz = speed;
    spi_transfer.bits_per_word = bits;
    spi_transfer.delay_usecs = 0;
    
    // Comando de lectura
    tx_buffer[0] = READ;
    tx_buffer[1] = 0xFC;
    tx_buffer[2] = 0x00;
    
    // Realizar transferencia
    int ret = ioctl(fd, SPI_IOC_MESSAGE(1), &spi_transfer);
    if(ret != 0) {
        perror("Error en transferencia SPI");
        close(fd);
        return 1;
    }
    
    // Mostrar resultados
    std::cout << "\nDatos recibidos:" << std::endl;
    std::cout << "  rx_buf[0-2]: 0x" << std::hex << std::setw(2) << std::setfill('0')
              << (int)rx_buffer[0] << " 0x" << (int)rx_buffer[1] << " 0x" 
              << (int)rx_buffer[2] << std::dec << std::endl;
    
    // Mostrar todos los buffers que cambiaron
    bool data_found = false;
    for(int i = 0; i < MAX_BUFFER_SIZE; ++i) {
        if(rx_buffer[i] != 0xFF) {
            if(!data_found) {
                std::cout << "\nDatos no predeterminados encontrados:" << std::endl;
                data_found = true;
            }
            std::cout << "  buffer[" << std::dec << i << "] = 0x" 
                      << std::hex << (int)rx_buffer[i] << std::dec << std::endl;
        }
    }
    
    if(!data_found) {
        std::cout << "\nNo se encontraron datos (todos 0xFF)" << std::endl;
    }
    
    close(fd);
    std::cout << "\n=== Test completado ===" << std::endl;
    return 0;
}

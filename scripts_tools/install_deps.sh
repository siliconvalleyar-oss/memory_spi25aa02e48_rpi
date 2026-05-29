#!/bin/bash

echo "========================================="
echo "Instalando dependencias para SPI EEPROM"
echo "========================================="

# Colores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Actualizar repositorios
echo -e "${YELLOW}Actualizando repositorios...${NC}"
sudo apt-get update

# Instalar herramientas de compilación
echo -e "${YELLOW}Instalando build-essential y cmake...${NC}"
sudo apt-get install -y build-essential cmake g++ tree

# Habilitar SPI en Raspberry Pi
echo -e "${YELLOW}Habilitando interfaz SPI...${NC}"
sudo raspi-config nonint do_spi 0

# Agregar usuario al grupo spi
echo -e "${YELLOW}Agregando usuario al grupo spi...${NC}"
sudo usermod -a -G spi $USER

# Verificar que el dispositivo SPI esté disponible
echo -e "${YELLOW}Verificando dispositivos SPI...${NC}"
if [ -e /dev/spidev0.0 ]; then
    echo -e "${GREEN}✓ Dispositivo SPI encontrado: /dev/spidev0.0${NC}"
else
    echo -e "${RED}⚠ Dispositivo SPI no encontrado. Reinicie el sistema para aplicar cambios.${NC}"
fi

# Mostrar información de grupos
echo -e "${GREEN}✓ Instalación completada${NC}"
echo -e "${YELLOW}IMPORTANTE: Para que los cambios surtan efecto, reinicie el sistema:${NC}"
echo "  sudo reboot"
echo ""
echo "O cierre sesión y vuelva a iniciar."

# Compilador y flags
CXX = g++
CXXFLAGS = -std=c++17 -Wall -Wextra -Wpedantic -O2
INCLUDES = -I./include
LDFLAGS = 

# Directorios
SRC_DIR = src
OBJ_DIR = obj
BIN_DIR = bin
BUILD_DIR = build

# Archivos fuente y objetos
SOURCES = $(wildcard $(SRC_DIR)/*.cpp)
OBJECTS = $(SOURCES:$(SRC_DIR)/%.cpp=$(OBJ_DIR)/%.o)
TARGET = $(BIN_DIR)/app_25aa

# Colores para output
RED = \033[0;31m
GREEN = \033[0;32m
YELLOW = \033[0;33m
NC = \033[0m # No Color

# Regla principal
all: $(TARGET)

# Crear directorios necesarios
$(OBJ_DIR) $(BIN_DIR):
	@mkdir -p $@
	@echo "$(GREEN)✓ Directorio $@ creado$(NC)"

# Linkear el ejecutable final
$(TARGET): $(OBJECTS) | $(BIN_DIR)
	@echo "$(YELLOW)Linkeando ejecutable...$(NC)"
	$(CXX) $(OBJECTS) -o $@ $(LDFLAGS)
	@echo "$(GREEN)✓ Ejecutable creado: $@$(NC)"

# Compilar cada archivo fuente
$(OBJ_DIR)/%.o: $(SRC_DIR)/%.cpp | $(OBJ_DIR)
	@echo "$(YELLOW)Compilando $<...$(NC)"
	$(CXX) $(CXXFLAGS) $(INCLUDES) -c $< -o $@
	@echo "$(GREEN)✓ $@ generado$(NC)"

# Limpiar archivos compilados
clean:
	@echo "$(YELLOW)Limpiando archivos...$(NC)"
	@rm -rf $(OBJ_DIR)/*.o $(TARGET)
	@echo "$(GREEN)✓ Limpieza completada$(NC)"

# Limpieza completa (incluye directorios)
distclean: clean
	@echo "$(YELLOW)Limpiando completamente...$(NC)"
	@rm -rf $(OBJ_DIR) $(BIN_DIR) $(BUILD_DIR)
	@echo "$(GREEN)✓ Limpieza completa$(NC)"

# Ejecutar el programa (requiere sudo)
run: $(TARGET)
	@echo "$(YELLOW)Ejecutando programa...$(NC)"
	sudo ./$(TARGET)

# Ejecutar sin sudo (si el usuario está en grupo spi)
run-local: $(TARGET)
	@echo "$(YELLOW)Ejecutando programa...$(NC)"
	./$(TARGET)

# Instalar dependencias
install-deps:
	@echo "$(YELLOW)Instalando dependencias...$(NC)"
	@chmod +x scripts/install_deps.sh
	@sudo ./scripts/install_deps.sh

# Mostrar estructura del proyecto
tree:
	@echo "$(GREEN)Estructura del proyecto:$(NC)"
	@tree -L 3 -I 'build|obj|bin' --dirsfirst

# Verificar permisos y configuración
check:
	@echo "$(YELLOW)Verificando configuración...$(NC)"
	@if [ -e /dev/spidev0.0 ]; then \
		echo "$(GREEN)✓ Dispositivo SPI encontrado: /dev/spidev0.0$(NC)"; \
	else \
		echo "$(RED)✗ Dispositivo SPI no encontrado. Ejecute: sudo raspi-config$(NC)"; \
	fi
	@if groups $$USER | grep -q spi; then \
		echo "$(GREEN)✓ Usuario $$USER está en grupo 'spi'$(NC)"; \
	else \
		echo "$(RED)✗ Usuario $$USER NO está en grupo 'spi'$(NC)"; \
	fi

# Ayuda
help:
	@echo "$(GREEN)Comandos disponibles:$(NC)"
	@echo "  make all         - Compilar el proyecto"
	@echo "  make clean       - Limpiar archivos objeto"
	@echo "  make distclean   - Limpieza completa"
	@echo "  make run         - Ejecutar (con sudo)"
	@echo "  make run-local   - Ejecutar (sin sudo)"
	@echo "  make install-deps- Instalar dependencias"
	@echo "  make tree        - Mostrar estructura"
	@echo "  make check       - Verificar configuración"
	@echo "  make help        - Mostrar esta ayuda"

# Phony targets (no son archivos reales)
.PHONY: all clean distclean run run-local install-deps tree check help

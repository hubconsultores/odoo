# 1. Usar la imagen base oficial (para todas las dependencias)
FROM odoo:19.0

# 2. [LA SOLUCIÓN 1] Cambiamos temporalmente al usuario ROOT
#    para tener permisos de escritura en /usr/lib/
USER root

# 3. [EL PASO CLAVE] Eliminar el código Community "viejo"
RUN rm -rf /usr/lib/python3/dist-packages/odoo/*

# 4. Copiar el código Community "nuevo" (desde este repositorio)
COPY . /usr/lib/python3/dist-packages/odoo/

# 5. Reinstalar Odoo desde esta nueva copia para
#    actualizar los ejecutables (como odoo-bin).
#    [LA SOLUCIÓN 2] Añadimos --break-system-packages
RUN pip install --break-system-packages /usr/lib/python3/dist-packages/odoo/

# 6. [BUENA PRÁCTICA] Volvemos al usuario 'odoo'
#    para que el contenedor se ejecute de forma segura.
USER odoo

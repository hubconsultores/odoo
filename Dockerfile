# 1. Usar la imagen base oficial (para todas las dependencias)
FROM odoo:19.0

# 2. [EL PASO CLAVE] Eliminar el código Community "viejo"
#    que venía en la imagen base.
RUN rm -rf /usr/lib/python3/dist-packages/odoo/*

# 3. Copiar el código Community "nuevo" (desde este repositorio)
#    al lugar donde la imagen base espera encontrarlo.
COPY . /usr/lib/python3/dist-packages/odoo/

# 4. Reinstalar Odoo desde esta nueva copia para
#    actualizar los ejecutables (como odoo-bin).
RUN pip install /usr/lib/python3/dist-packages/odoo/

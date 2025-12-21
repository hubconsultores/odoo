FROM odoo:19.0

USER root

# Carpeta del código de tu fork
RUN mkdir -p /opt/odoo && chown -R odoo:odoo /opt/odoo

# Copia tu fork (community + server) dentro del contenedor
COPY --chown=odoo:odoo . /opt/odoo

# IMPORTANTE:
# - NO ejecutes `pip install -r requirements.txt` del repo, porque el contenedor ya trae dependencias
#   instaladas por Debian y pip intenta desinstalarlas y rompe (lo viste con cryptography).
# - Si necesitas dependencias extra de tus módulos, crea un archivo `requirements-extra.txt`
#   (solo lo adicional) y se instala abajo.

RUN if [ -f /opt/odoo/requirements-extra.txt ]; then \
      pip install --no-cache-dir --break-system-packages -r /opt/odoo/requirements-extra.txt; \
    fi

USER odoo

# Ejecutar SIEMPRE el odoo-bin de tu fork
CMD ["/opt/odoo/odoo-bin", "-c", "/etc/odoo/odoo.conf"]

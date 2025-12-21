# Imagen base oficial (trae wkhtmltopdf, deps, usuario odoo, etc.)
FROM odoo:19.0

USER root

# --- Build args típicos de EasyPanel (los que ya estás usando) ---
ARG HOST
ARG PORT=5432
ARG USER=odoo
ARG PASSWORD

# 1) Copiamos TU FORK (community) a una ruta limpia
#    (NO tocar /usr/lib/python3/dist-packages/odoo del sistema)
RUN mkdir -p /opt/odoo
COPY . /opt/odoo

# 2) Dependencias python del fork (si tu fork trae requirements.txt)
#    Nota: en la imagen oficial ya hay muchas deps instaladas,
#    pero esto evita desajustes.
RUN if [ -f /opt/odoo/requirements.txt ]; then \
      pip install --no-cache-dir --break-system-packages -r /opt/odoo/requirements.txt; \
    fi

# 3) Preparamos carpetas donde EasyPanel montará volúmenes
RUN mkdir -p /mnt/enterprise /mnt/extra-addons /mnt/moduloshub /var/lib/odoo \
 && chown -R odoo:odoo /mnt/enterprise /mnt/extra-addons /mnt/moduloshub /var/lib/odoo

# 4) Generamos un odoo.conf estable (addons_path bien definido)
#    IMPORTANTE: incluimos /opt/odoo/addons (community) + enterprise + extras
RUN mkdir -p /etc/odoo \
 && printf "%s\n" \
"[options]" \
"proxy_mode = True" \
"data_dir = /var/lib/odoo" \
"db_host = ${HOST}" \
"db_port = ${PORT}" \
"db_user = ${USER}" \
"db_password = ${PASSWORD}" \
"addons_path = /opt/odoo/addons,/mnt/enterprise,/mnt/extra-addons,/mnt/moduloshub" \
"server_wide_modules = web" \
> /etc/odoo/odoo.conf \
 && chown -R odoo:odoo /etc/odoo

# 5) Script de arranque: ejecuta TU odoo-bin, no el del sistema
RUN printf '%s\n' \
"#!/bin/bash" \
"set -e" \
"exec python3 /opt/odoo/odoo-bin -c /etc/odoo/odoo.conf \"\$@\"" \
> /usr/local/bin/start-odoo \
 && chmod +x /usr/local/bin/start-odoo \
 && chown odoo:odoo /usr/local/bin/start-odoo

USER odoo

# En runtime, EasyPanel montará volúmenes en /mnt/enterprise y /mnt/extra-addons
# Este CMD arranca tu core.
CMD ["/usr/local/bin/start-odoo"]

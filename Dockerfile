FROM odoo:19.0

USER root

# Crea puntos de montaje (Easypanel montará volúmenes aquí)
RUN mkdir -p /mnt/enterprise /mnt/extra-addons /mnt/moduloshub \
    && chown -R odoo:odoo /mnt/enterprise /mnt/extra-addons /mnt/moduloshub

# (Opcional) Si tienes un requirements propio SOLO de tus addons, instálalo aquí:
# - OJO: NO uses el requirements.txt del core de Odoo
# COPY ./requirements-extra.txt /tmp/requirements-extra.txt
# RUN pip install --no-cache-dir --break-system-packages -r /tmp/requirements-extra.txt

USER odoo

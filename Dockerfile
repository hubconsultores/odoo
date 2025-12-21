FROM odoo:19.0

USER root

# Solo copias enterprise y tus addons extra (NO el core de Odoo)
COPY ./enterprise /mnt/enterprise
COPY ./extra-addons /mnt/extra-addons

# permisos si hace falta
RUN chown -R odoo:odoo /mnt/enterprise /mnt/extra-addons /mnt/moduloshub

USER odoo

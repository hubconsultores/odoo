FROM odoo:19.0

# Opcional: si quieres asegurar que existan las carpetas de addons aunque estén vacías
USER root
RUN mkdir -p /mnt/enterprise /mnt/extra-addons /mnt/moduloshub \
    && chown -R odoo:odoo /mnt/enterprise /mnt/extra-addons /mnt/moduloshub
USER odoo

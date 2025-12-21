FROM odoo:19.0

# Copiamos TU fork del core a /opt/odoo (sin tocar /usr/lib)
USER root
RUN mkdir -p /opt/odoo && chown -R odoo:odoo /opt/odoo

USER odoo
COPY --chown=odoo:odoo . /opt/odoo

# Importante: NO copiamos /enterprise ni /extra-addons aquí,
# porque en Easypanel los tienes como VOLUMENES montados en /mnt/enterprise, etc.

# Ejecutar el core desde tu fork
# (usamos el odoo.conf del contenedor: /etc/odoo/odoo.conf)
CMD ["python3", "/opt/odoo/odoo-bin", "-c", "/etc/odoo/odoo.conf"]

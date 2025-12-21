FROM odoo:19.0

USER root

# 1) Copiamos TU core (fork) a /opt/odoo
#    (NO tocamos /usr/lib/python3/dist-packages/odoo)
RUN mkdir -p /opt/odoo
COPY . /opt/odoo

# 2) Permisos (por si easypanel monta con uid distinto)
RUN chown -R odoo:odoo /opt/odoo

# 3) Creamos un odoo.conf “mínimo” (puedes sobreescribirlo con volumen si quieres)
#    OJO: enterprise/extra-addons están en addons_path pero se montan como volumen desde Easypanel.
RUN printf "%s\n" \
"[options]" \
"proxy_mode = True" \
"data_dir = /var/lib/odoo" \
"addons_path = /opt/odoo/odoo/addons,/mnt/enterprise,/mnt/extra-addons,/mnt/moduloshub" \
"admin_passwd = ${ODOO_ADMIN_PASSWD:-admin}" \
> /etc/odoo/odoo.conf && \
chown odoo:odoo /etc/odoo/odoo.conf

USER odoo

# 4) MUY IMPORTANTE: ejecutamos SIEMPRE el odoo-bin de /opt/odoo
#    Así no entra en juego el core “debian” de /usr/lib/...
CMD ["/opt/odoo/odoo-bin", "-c", "/etc/odoo/odoo.conf"]

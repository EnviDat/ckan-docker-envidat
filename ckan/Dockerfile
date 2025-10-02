FROM ckan/ckan-base:2.11.3

# Install any extensions needed by your CKAN instance
# See Dockerfile for more details and examples

USER root

# default user id and user group id
ARG UID=1000
ARG GID=1000

# Install packages needed by official ckanext-scheming extension
RUN apt-get update && apt-get install -y \
    libxml2-dev \
    libxslt1-dev \
    libgeos-dev \
    && rm -rf /var/lib/apt/lists/*

# establish a ckan-sys user on the host machine, add it if it's not there otherwise change it
RUN if ! getent group ckan-sys >/dev/null; then \
      groupadd -g "${GID}" ckan-sys; \
    else \
      groupmod -g "${GID}" ckan-sys; \
    fi && \
    if ! id -u ckan-sys >/dev/null 2>&1; then \
      useradd -u "${UID}" -g "${GID}" -m -s /bin/bash ckan-sys; \
    else \
      usermod -u "${UID}" -g "${GID}" ckan-sys; \
    fi


# passwordless_api
RUN pip install -e git+https://gitlabext.wsl.ch/EnviDat/ckan_extensions/ckanext-passwordless_api.git@1.1.11#egg=ckanext-passwordless_api

# scheming
RUN pip install -e git+https://github.com/ckan/ckanext-scheming.git@release-3.1.0#egg=ckanext-scheming

# hierarchy (used by ckanext-envidat_theme)
RUN pip install -e git+https://github.com/ckan/ckanext-hierarchy.git@v1.2.2#egg=ckanext-hierarchy

# envidat_theme (has schemas used by ckanext-scheming)
RUN pip install -e git+https://gitlabext.wsl.ch/EnviDat/ckan_extensions/ckanext-envidat_theme.git@2.0.0#egg=ckanext-envidat_theme

# spatial (has snippets used by ckanext-envidat_theme)
RUN pip install -e git+https://github.com/ckan/ckanext-spatial.git@v2.3.1#egg=ckanext-spatial
RUN pip install -r /srv/app/src/ckanext-spatial/requirements.txt

# composite (used by "datacite_dataset.json" in ckanext-envidat_theme)
RUN pip install -e git+https://gitlabext.wsl.ch/EnviDat/ckan_extensions/ckanext-composite.git@0.0.4#egg=ckanext-composite

# restricted
RUN pip install -e git+https://gitlabext.wsl.ch/EnviDat/ckan_extensions/ckanext-restricted.git@1.0.0#egg=ckanext-restricted
# RUN chown -R ckan-sys:ckan-sys /var/lib/ckan/
# RUN mkdir -p /var/lib/ckan/i18n

# cloudstorage (used by "ckanext/envidat_theme/templates/scheming/package/resource_read.html" in ckanext-envidat_theme)
RUN pip install -e git+https://gitlabext.wsl.ch/EnviDat/ckan_extensions/ckanext-cloudstorage@2.0.0#egg=ckanext-cloudstorage
RUN pip install -r /srv/app/src/ckanext-cloudstorage/requirements.txt

# blind_review
RUN pip install -e git+https://gitlabext.wsl.ch/EnviDat/ckan_extensions/ckanext-blind_review.git@2.0.0#egg=ckanext_blind_review
# RUN chown -R ckan-sys:ckan-sys /srv/app/

########################################################################################
# Copy custom initialization scripts
COPY --chown=ckan-sys:ckan-sys docker-entrypoint.d/* /docker-entrypoint.d/

RUN for f in /docker-entrypoint.d/*; do \
      # convert file windows ending and grant execute permissions
      sed -i 's/\r$//' "$f" && chmod +x "$f"; \
    done

# Apply any patches needed to CKAN core or any of the built extensions (not the
# runtime mounted ones)
COPY --chown=ckan-sys:ckan-sys patches ${APP_DIR}/patches

RUN for d in $APP_DIR/patches/*; do \
        if [ -d $d ]; then \
            for f in `ls $d/*.patch | sort -g`; do \
                cd $SRC_DIR/`basename "$d"` && echo "$0: Applying patch $f to $SRC_DIR/`basename $d`"; patch -p1 < "$f" ; \
            done ; \
        fi ; \
    done

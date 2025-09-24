FROM ckan/ckan-dev:2.11.3

# Install any extensions needed by your CKAN instance
# See Dockerfile.dev for more details and examples

# TODO possibly remove installation below after ckanext-spatial is updated
# Install packages needed by official ckanext-scheming extension
USER root
RUN apt-get update && apt-get install -y \
    libxml2-dev \
    libxslt1-dev \
    libgeos-dev \
    && rm -rf /var/lib/apt/lists/*

# passwordless_api
RUN pip install -e git+https://gitlabext.wsl.ch/EnviDat/ckanext-passwordless_api.git@1.1.9#egg=ckanext-passwordless_api

# scheming
RUN pip install -e git+https://github.com/ckan/ckanext-scheming.git@release-3.1.0#egg=ckanext-scheming

# hierarchy (used by ckanext-envidat_theme)
RUN pip install -e git+https://github.com/ckan/ckanext-hierarchy.git@v1.2.2#egg=ckanext-hierarchy

# envidat_theme (has schemas used by ckanext-scheming)
RUN pip install -e git+https://gitlabext.wsl.ch/EnviDat/ckan_extensions/ckanext-envidat_theme.git@ckan-2-11#egg=ckanext-envidat_theme

# spatial (has snippets used by ckanext-envidat_theme)
RUN pip install -e git+https://github.com/ckan/ckanext-spatial.git@v2.3.1#egg=ckanext-spatial
RUN pip install -r /srv/app/src/ckanext-spatial/requirements.txt

# TODO test
# composite (used by "datacite_dataset.json" in ckanext-envidat_theme)
RUN pip install -e git+https://gitlabext.wsl.ch/EnviDat/ckan_extensions/ckanext-composite.git@ckan-2-11#egg=ckanext-composite

# restricted
RUN pip install -e git+https://gitlabext.wsl.ch/EnviDat/ckan_extensions/ckanext-restricted.git@1.0.0#egg=ckanext-restricted
# Fix permissions for CKAN
RUN mkdir -p /var/lib/ckan/i18n && \
    chown -R ckan:ckan-sys /var/lib/ckan

# TODO test add configuration settings
# cloudstorage (used by "ckanext/envidat_theme/templates/scheming/package/resource_read.html" in ckanext-envidat_theme)
RUN pip install -e git+https://gitlabext.wsl.ch/EnviDat/ckan_extensions/ckanext-cloudstorage@ckan-2-11#egg=ckanext-cloudstorage
RUN pip install -r /srv/app/src/ckanext-cloudstorage/requirements.txt

# blind_review
RUN pip install -e git+https://gitlabext.wsl.ch/EnviDat/ckanext-blind_review.git@2.0.0#egg=ckanext_blind_review
RUN chown -R ckan:ckan-sys /srv/app/src

# Build assets for extensions
RUN ckan asset build

########################################################################################
# Copy custom initialization scripts
COPY --chown=ckan-sys:ckan-sys docker-entrypoint.d/* /docker-entrypoint.d/

# Apply any patches needed to CKAN core or any of the built extensions (not the
# runtime mounted ones)
COPY --chown=ckan-sys:ckan-sys patches ${APP_DIR}/patches

USER ckan

RUN for d in $APP_DIR/patches/*; do \
        if [ -d $d ]; then \
            for f in `ls $d/*.patch | sort -g`; do \
                cd $SRC_DIR/`basename "$d"` && echo "$0: Applying patch $f to $SRC_DIR/`basename $d`"; patch -p1 < "$f" ; \
            done ; \
        fi ; \
    done

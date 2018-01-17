FROM exocom/amazonlinux-node:6.10.3


ENV LIBPNG_VERSION 1.6.21
ENV PIXMAN_VERSION 0.34.0
ENV FREETYPE_VERSION 2.6
ENV CAIRO_VERSION 1.14.6
ENV GIFLIB_VERSION 5.1.3
ENV LIBXML2_VERSION 2.9.3
ENV FONTCONFIG_VERSION 2.11.1

ENV TMP_INSTALL_PREFIX /canvas

ENV SRC_DIR /user/local/src
ENV DIR /var/task
ENV CANVAS_INSTALL_PREFIX ${DIR}/build

RUN mkdir -p ${CANVAS_INSTALL_PREFIX}

RUN yum update -y \
      && yum install -y zlib-devel
      
ENV LDFLAGS -Wl,-rpath=${DIR}/lib/
ENV PKG_CONFIG_PATH ${TMP_INSTALL_PREFIX}/lib/pkgconfig
ENV LD_LIBRARY_PATH ${TMP_INSTALL_PREFIX}/lib:$LD_LIBRARY_PATH

ENV C_INCLUDE_PATH ${TMP_INSTALL_PREFIX}/include/
ENV CPLUS_INCLUDE_PATH ${TMP_INSTALL_PREFIX}/include/

RUN cd ${SRC_DIR} \
    && curl -L http://downloads.sourceforge.net/libpng/libpng-${LIBPNG_VERSION}.tar.xz -o libpng-${LIBPNG_VERSION}.tar.xz \
    && tar -Jxf libpng-${LIBPNG_VERSION}.tar.xz && cd libpng-${LIBPNG_VERSION} \
    && ./configure --prefix=${TMP_INSTALL_PREFIX} \
    && make \
    && sudo make install

RUN cd ${SRC_DIR} \
    && curl http://www.ijg.org/files/jpegsrc.v8d.tar.gz -o jpegsrc.v8d.tar.gz \
    && tar -zxf jpegsrc.v8d.tar.gz && cd jpeg-8d/  \
    && ./configure --disable-dependency-tracking --prefix=${TMP_INSTALL_PREFIX}  \
    && make  \
    && sudo make install

RUN cd ${SRC_DIR} \
    && curl -L http://www.cairographics.org/releases/pixman-${PIXMAN_VERSION}.tar.gz -o pixman-${PIXMAN_VERSION}.tar.gz  \
    && tar -zxf pixman-${PIXMAN_VERSION}.tar.gz && cd pixman-${PIXMAN_VERSION}/  \
    && ./configure --prefix=${TMP_INSTALL_PREFIX}  \
    && make  \
    && sudo make install

RUN cd ${SRC_DIR} \
    && curl -L http://download.savannah.gnu.org/releases/freetype/freetype-${FREETYPE_VERSION}.tar.gz -o freetype-${FREETYPE_VERSION}.tar.gz  \
    && tar -zxf freetype-${FREETYPE_VERSION}.tar.gz && cd freetype-${FREETYPE_VERSION}/  \
    && ./configure --prefix=${TMP_INSTALL_PREFIX}  \
    && make  \
    && sudo make install  \
    
RUN cd ${SRC_DIR} \
    && curl -L http://cairographics.org/releases/cairo-${CAIRO_VERSION}.tar.xz -o cairo-${CAIRO_VERSION}.tar.xz  \
    && tar -Jxf cairo-${CAIRO_VERSION}.tar.xz && cd cairo-${CAIRO_VERSION}  \
    && ./configure --disable-dependency-tracking --without-x --prefix=${TMP_INSTALL_PREFIX}  \
    && make  \
    && sudo make install

RUN cd ${SRC_DIR} \
    && curl -L http://downloads.sourceforge.net/giflib/giflib-${GIFLIB_VERSION}.tar.bz2 -o giflib-${GIFLIB_VERSION}.tar.bz2  \
    && tar -xvjf giflib-${GIFLIB_VERSION}.tar.bz2 && cd giflib-${GIFLIB_VERSION}  \
    && ./configure --prefix=${TMP_INSTALL_PREFIX}  \
    && make  \
    && sudo make install

RUN cd ${SRC_DIR} \
    && curl -L http://xmlsoft.org/sources/libxml2-${LIBXML2_VERSION}.tar.gz -o libxml2-${LIBXML2_VERSION}.tar.gz  \
    && tar -zxf libxml2-${LIBXML2_VERSION}.tar.gz && cd libxml2-${LIBXML2_VERSION}  \
    && ./configure --prefix=${TMP_INSTALL_PREFIX}  \
    && make  \
    && sudo make install

RUN cd ${SRC_DIR} \
    && curl -L http://www.freedesktop.org/software/fontconfig/release/fontconfig-${FONTCONFIG_VERSION}.tar.bz2 -o fontconfig-${FONTCONFIG_VERSION}.tar.bz2  \
    && tar -xvjf fontconfig-${FONTCONFIG_VERSION}.tar.bz2 && cd fontconfig-${FONTCONFIG_VERSION}  \
    && ./configure --prefix=${TMP_INSTALL_PREFIX}  --enable-libxml2  \
    && make  \
    && sudo make install

RUN mkdir -p ${CANVAS_INSTALL_PREFIX}

RUN cp -L ${TMP_INSTALL_PREFIX}/lib/*.so* ${CANVAS_INSTALL_PREFIX}
FROM ubuntu:16.04
LABEL maintainer="Nick Dat Le <nick_dat_le@yahoo.com>"
RUN apt update \
    && apt upgrade --yes \
    && apt install git --yes \
    && apt install automake --yes \
    && apt install autoconf --yes \
    && apt install libtool --yes \
    && apt install perl --yes \
    && apt install make --yes
RUN git clone https://github.com/libressl-portable/portable.git
#COPY ./ /portable/
WORKDIR /portable

 # see ./configure --help for configuration options
 # runs builtin unit tests
 # set DESTDIR= to install to an alternate location
RUN ./autogen.sh \
    && ./configure \
    && make check    \
    && make install

# Seems to be a bug with this process, which gave these two errors:
# openssl: error while loading shared libraries: libssl.so.48: cannot open shared object file: No such file or directory
# openssl: error while loading shared libraries: libcrypto.so.46: cannot open shared object file: No such file or directory
# Solution from https://stackoverflow.com/questions/54124906/openssl-error-while-loading-shared-libraries-libssl-so-3
# This is very much a hack and is NOT recommended
RUN cp /usr/local/lib/libssl.so.48 /usr/lib
RUN cp /usr/local/lib/libcrypto.so.46 /usr/lib
RUN rm -r /portable

#ENTRYPOINT ["openssl"]
CMD ["bash"]
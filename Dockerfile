# Start with a rust alpine image
FROM rust:1-alpine3.16
# This is important, see https://github.com/rust-lang/docker-rust/issues/85
ENV RUSTFLAGS="-C target-feature=-crt-static"
# if needed, add additional dependencies here
RUN apk add --no-cache musl-dev
# set the workdir and copy the source into it
WORKDIR /app
COPY ./ /app
# do a release build
RUN cargo build --release
RUN strip target/release/mini-docker-rust

# use a plain alpine image, the alpine version needs to match the builder
FROM alpine:3.16
# if needed, install additional dependencies here
RUN apk add --no-cache libgcc
# copy the binary into the final image
COPY --from=0 /app/target/release/mini-docker-rust .
# set the binary as entrypoint
ENTRYPOINT ["/mini-docker-rust"]

# docker run -w /root -it --rm alpine:edge sh -uelic '
#   apk add bash git lua nodejs npm lazygit bottom python3 go neovim ripgrep alpine-sdk --update
#   git clone https://github.com/AstroNvim/AstroNvim ~/.config/nvim
#   git clone https://github.com/username/AstroNvim_user ~/.config/nvim/lua/user
#   nvim --headless -c "autocmd User PackerComplete quitall"
#   nvim
# '

# # Base image
# FROM alpine:edge
# # Install dependencies
# RUN apk add bash git lua nodejs npm lazygit bottom python3 go neovim ripgrep alpine-sdk --update
# # Clone AstroNvim
# RUN git clone https://github.com/AstroNvim/AstroNvim ~/.config/nvim
# COPY ../.config/lua/user ~/.config/nvim/lua/user
# # Install plugins
# RUN nvim --headless -c "autocmd User PackerComplete quitall"
# # Run nvim
# CMD nvim

# Elm Site Template

Elm Site Template is a minimal dependency Elm project template with TailwindCSS using [Elm Tailwind Modules](https://github.com/matheus23/elm-tailwind-modules) and a live dev server using [Elm Live](https://github.com/wking-io/elm-live).

This project relies on a couple helper scripts in the `package.json`.

## Dependencies

You need to have npm/yarn installed.

Install dependencies:

```sh
yarn install
# or
npm install
```

## Scripts

Run scripts with:

```sh
yarn <script>
# or
npm run <script>
```

### `gen`

Generates Tailwind modules into the `gen/` directory.\
More about Tailwind Modules here: https://github.com/matheus23/elm-tailwind-modules

### `format`

Formats the Elm files in the `src/` directory.

### `dev`

Creates `live/` directory and copies `static/` content into it. Compiles `src/Main.elm` into `live/dist/` and starts live server in debug mode.\
More about Elm Live here: https://github.com/wking-io/elm-live

### `build`

Creates `public/` directory and copies `static/` content into it. Compiles optimized build of `src/Main.elm` into `public/dist/`.

## Structure

```
.
├── gen/
│   └── ..
├── live/
│   └── ..
├── public/
│   └── ..
├── src/
│   └── Main.elm
└── static/
    └── index.html
```

### `gen/`

Contains the generated Tailwind modules after running the `gen` script.\
By default excluded in the `.gitignore`.

### `live/`

Contains the files running on the elm-live dev server using the `dev` script.\
By default excluded in the `.gitignore`.

### `public/`

Contains the built site after running the `build` script.\
Deploy this folder.\
By default excluded in the `.gitignore`.

### `src/`

Contains the Elm source code with `Main.elm` entrypoint.

### `static/`

Contains static files that don't need compiling including the `index.html` entrypoint.\
Contents get copied into the `public/` directory on build.\
Add your static files like pictures and fonts here.

## Deploy

To deploy run:

```sh
yarn build
# or
npm run build
```

And deploy the contents of the created `public/` directory to your webserver or favorite static site hoster.
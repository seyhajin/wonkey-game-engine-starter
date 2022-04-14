/*

// Building on Linux
TODO

// Building on Windows
TODO

// Building on MacOS
clang++ -std=c++14 ./src/hello.cc -o ./src/hello -I./native/include -L./native/lib/macos -DANGLE_EXPORT= -DANGLE_STATIC=1 -DANGLE_UTIL_EXPORT= -DEGLAPI= -DGL_APICALL= -DGL_API= -DKHRONOS_STATIC -lEGL_static -lSDL2 -lm -liconv -pthread -framework Foundation -framework IOKit -framework CoreFoundation -framework CoreGraphics -framework Metal -framework IOSurface -framework QuartzCore -framework Cocoa -framework GameController -framework CoreAudio -framework AudioToolbox -framework CoreHaptics -framework ForceFeedback -framework Carbon -framework AVFoundation

#defines:
    ANGLE_EXPORT=
    ANGLE_STATIC=1
    ANGLE_UTIL_EXPORT=
    EGLAPI=
    GL_APICALL=
    GL_API=

#include_dirs:
    angle/include
    sdl/include

#links:
    EGL_static
    SDL2

#syslinks:
    ##TOCHECK## windows: dxguid.lib, dxgi.lib
    ##TOCHECK## linux: atomic, dl, pthread, rt, X11, Xext, xcb
    macos: m, iconv, frameworks: Foundation, IOKit, CoreFoundation, CoreGraphics, OpenGL, IOSurface, QuaartzCore, Cocoa, GameController, CoreAudio, AudioToolbox, CoreHaptics, ForceFeedback, Carbon, AVFoundation

*/

#include <cstdio>
#include <cassert>

#include <GLES3/gl3.h>
#include <SDL2/SDL.h>

// vertex shader
static const char *VERT_SOURCE = R"(
attribute vec4 aPosition;
attribute vec4 aColor;
varying vec4 fragColor;
void main() {
    gl_Position = aPosition;
    fragColor = aColor;
}
)";

// fragment shader
static const char *FRAG_SOURCE = R"(
precision mediump float;
varying vec4 fragColor;
void main() {
    gl_FragColor = vec4(fragColor.rgb, 1.0);
}
)";

// helper function to create and compile shader from source
GLuint createShader(GLenum type, const char *source) {
    GLuint vert = glCreateShader(type);
    assert(glGetError() == GL_NO_ERROR);
    glShaderSource(vert, 1, &source, nullptr);
    glCompileShader(vert);
    GLint compiled = GL_FALSE;
    glGetShaderiv(vert, GL_COMPILE_STATUS, &compiled);
    assert(compiled == GL_TRUE);
    return vert;
}

// helper function to create and link program from shaders
GLuint createProgram() {
    GLuint vert = createShader(GL_VERTEX_SHADER, VERT_SOURCE);
    GLuint frag = createShader(GL_FRAGMENT_SHADER, FRAG_SOURCE);
    GLuint program = glCreateProgram();
    assert(glGetError() == GL_NO_ERROR);
    glAttachShader(program, vert);
    glAttachShader(program, frag);
    glLinkProgram(program);
    GLint linked = GL_FALSE;
    glGetProgramiv(program, GL_LINK_STATUS, &linked);
    assert(linked == GL_TRUE);
    glDeleteShader(vert);
    glDeleteShader(frag);
    return program;
}

int main() {

    // select graphics renderer
    SDL_setenv("ANGLE_DEFAULT_PLATFORM", "metal", 1);
    //SDL_setenv("ANGLE_DEFAULT_PLATFORM", "d3d11", 1);
    //SDL_setenv("ANGLE_DEFAULT_PLATFORM", "opengl", 1);


    // initialize SDL
    if (SDL_Init(SDL_INIT_VIDEO) != 0) {
        fprintf(stderr, "Could not init SDL\n");
        return 1;
    }

    // setup GLES3
    SDL_SetHint(SDL_HINT_OPENGL_ES_DRIVER, "1");
    SDL_GL_SetAttribute(SDL_GL_CONTEXT_PROFILE_MASK, SDL_GL_CONTEXT_PROFILE_ES);
    SDL_GL_SetAttribute(SDL_GL_CONTEXT_MAJOR_VERSION, 3);
    SDL_GL_SetAttribute(SDL_GL_CONTEXT_MINOR_VERSION, 0);
    SDL_GL_SetAttribute(SDL_GL_DOUBLEBUFFER, 1);
    SDL_GL_SetAttribute(SDL_GL_DEPTH_SIZE, 24);
    SDL_GL_SetAttribute(SDL_GL_BUFFER_SIZE, 32);
    SDL_GL_SetAttribute(SDL_GL_RED_SIZE, 8);
    SDL_GL_SetAttribute(SDL_GL_GREEN_SIZE, 8);
    SDL_GL_SetAttribute(SDL_GL_BLUE_SIZE, 8);
    SDL_GL_SetAttribute(SDL_GL_ALPHA_SIZE, 8);

    const int SIZE = 600;

    // create SDL window
    SDL_Window *window = nullptr;
    window = SDL_CreateWindow("wonkey 2d/3d game engine starter", SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED, SIZE, SIZE, SDL_WINDOW_OPENGL | SDL_WINDOW_ALLOW_HIGHDPI | SDL_WINDOW_SHOWN);
    if (window == nullptr) {
        fprintf(stderr, "Could not create SDL window: %s\n", SDL_GetError());
        return 1;
    }

    // create GL context
    SDL_GLContext glContext = nullptr;
    glContext = SDL_GL_CreateContext(window);
    assert(glContext != nullptr);
    SDL_GL_MakeCurrent(window, glContext);
    SDL_GL_SetSwapInterval(0);


    // SDL version
    SDL_version version;
    SDL_GetVersion(&version);
    fprintf(stdout, "SDL Version: %d.%d.%d\n", version.major, version.minor, version.patch);

    // GL version
    const GLubyte *glVendor = glGetString(GL_VENDOR);
    const GLubyte *glRenderer = glGetString(GL_RENDERER);
    const GLubyte *glVersion = glGetString(GL_VERSION);
    //const GLubyte *glExtensions = glGetString(GL_EXTENSIONS);
    const GLubyte *glShadingLang = glGetString(GL_SHADING_LANGUAGE_VERSION);
    fprintf(stdout, "GL Vendor: %s\n", glVendor);
    fprintf(stdout, "GL Renderer: %s\n", glRenderer);
    fprintf(stdout, "GL Version: %s\n", glVersion);
    fprintf(stdout, "GL Shading Language Version: %s\n", glShadingLang);
    //fprintf(stdout, "GL Extensions: %s\n", glExtensions);
    

    // simple quad example
    auto program = createProgram();
    auto aPosition = glGetAttribLocation(program, "aPosition"); assert(aPosition >= 0);
    auto aColor = glGetAttribLocation(program, "aColor"); assert(aColor >= 0);

    const float vertices[] = {
        -0.5f, -0.5f, // bottom-left
        +0.5f, -0.5f, // bottom-right
        -0.5f, +0.5f, // top-left
        +0.5f, -0.5f, // bottom-right
        -0.5f, +0.5f, // top-left
        +0.5f, +0.5f, // top-right
    };

    const float colors[] = {
        1.0f, 0.0f, 0.0f, // bottom-left
        0.0f, 1.0f, 0.0f, // bottom-right
        0.0f, 0.0f, 1.0f, // top-left
        0.0f, 1.0f, 0.0f, // bottom-right
        0.0f, 0.0f, 1.0f, // top-left
        1.0f, 0.0f, 1.0f, // top-right
    };


    //------------------------
    // main loop
    //------------------------
    bool running = true;
    while(running) {

        // event loop
        SDL_Event e;
        while (SDL_PollEvent(&e) != 0) {
            switch (e.type) {
                case SDL_QUIT:
                    running = false;
                    break;
                case SDL_KEYDOWN:
                    switch (e.key.keysym.sym) {
                        case SDLK_ESCAPE:
                            running = false;
                            break;
                    }
                    break;
            }
        }

        // render
        glViewport(0, 0, SIZE, SIZE);

        glClearColor(0.12f, 0.12f, 0.2f, 1.0f);
        glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT | GL_STENCIL_BUFFER_BIT);

        glUseProgram(program);
        glVertexAttribPointer(aPosition, 2, GL_FLOAT, GL_FALSE, 0, vertices);
        glEnableVertexAttribArray(aPosition);
        glVertexAttribPointer(aColor, 3, GL_FLOAT, GL_FALSE, 0, colors);
        glEnableVertexAttribArray(aColor);
        glDrawArrays(GL_TRIANGLES, 0, 6);
        glFlush();

        // swap
        SDL_GL_SwapWindow(window);
    }
    

    // destroy all resources
    SDL_GL_DeleteContext(glContext);
    SDL_DestroyWindow(window);
    SDL_Quit();

    return 0;
}
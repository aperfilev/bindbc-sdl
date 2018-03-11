module bindbc.sdl.bind.sdlrect;

import bindbc.sdl.bind.sdlstdinc : SDL_bool;

struct SDL_Point {
    int x;
    int y;
}

struct SDL_Rect {
    int x, y;
    int w, h;
}

@nogc nothrow pure {
    // This macro was added to SDL_rect.h in 2.0.4, but hurts nothing to implement for
    // all versions.
    bool SDL_PointInRect(const SDL_Point *p, const SDL_Rect *r) {
        pragma(inline, true);
        return ((p.x >= r.x) && (p.x < (r.x + r.w)) &&
                (p.y >= r.y) && (p.y < (r.y + r.h)));
    }

    bool SDL_RectEmpty(const(SDL_Rect)* X) {
        pragma(inline, true);
        return !X || (X.w <= 0) || (X.h <= 0);
    }

    bool SDL_RectEquals(const(SDL_Rect)* A, const(SDL_Rect)* B) {
        pragma(inline, true);
        return A && B &&
            (A.x == B.x) && (A.y == B.y) &&
            (A.w == B.w) && (A.h == B.h);
    }
}

version(BindSDL_Static) {
    extern(C) @nogc nothrow {
        SDL_bool SDL_HasIntersection(const(SDL_Rect)*,const(SDL_Rect)*);
        SDL_bool SDL_IntersectRect(const(SDL_Rect)*,const(SDL_Rect)*,SDL_Rect*);
        void SDL_UnionRect(const(SDL_Rect)*,const(SDL_Rect)*,SDL_Rect*);
        SDL_bool SDL_EnclosePoints(const(SDL_Point)*,int,const(SDL_Rect)*,SDL_Rect*);
        SDL_bool SDL_IntersectRectAndLine(const(SDL_Rect)*,int*,int*,int*,int*);
    }
}
else {
    extern(C) @nogc nothrow {
        alias pSDL_HasIntersection = SDL_bool function(const(SDL_Rect)*,const(SDL_Rect)*);
        alias pSDL_IntersectRect = SDL_bool function(const(SDL_Rect)*,const(SDL_Rect)*,SDL_Rect*);
        alias pSDL_UnionRect = void function(const(SDL_Rect)*,const(SDL_Rect)*,SDL_Rect*);
        alias pSDL_EnclosePoints = SDL_bool function(const(SDL_Point)*,int,const(SDL_Rect)*,SDL_Rect*);
        alias pSDL_IntersectRectAndLine = SDL_bool function(const(SDL_Rect)*,int*,int*,int*,int*);
    }

    __gshared {
        pSDL_HasIntersection SDL_HasIntersection;
        pSDL_IntersectRect SDL_IntersectRect;
        pSDL_UnionRect SDL_UnionRect;
        pSDL_EnclosePoints SDL_EnclosePoints;
        pSDL_IntersectRectAndLine SDL_IntersectRectAndLine;
    }
}
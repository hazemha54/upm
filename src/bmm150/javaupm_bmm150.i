%module javaupm_bmm150
%include "../upm.i"
%include "typemaps.i"
%include "../upm_javastdvector.i"

%ignore getMagnetometer(float *, float *, float *);

%typemap(javaimports) SWIGTYPE %{
import java.util.AbstractList;
import java.lang.Float;
%}

%typemap(javaout) SWIGTYPE {
    return new $&javaclassname($jnicall, true);
}
%typemap(javaout) std::vector<float> {
    return (AbstractList<Float>)(new $&javaclassname($jnicall, true));
}
%typemap(jstype) std::vector<float> "AbstractList<Float>"

%template(floatVector) std::vector<float>;

%{
    #include "bmm150.hpp"
    #include "bmm150_defs.h"
%}
%include "bmm150_defs.h"
%include "bmm150.hpp"

%ignore installISR (BMM150_INTERRUPT_PINS_T , int ,  mraa::Edge ,  void *, void *);

%extend upm::BMM150 {
    void installISR(BMM150_INTERRUPT_PINS_T intr, int gpio,
                    mraa::Edge level,
                    jobject runnable)
    {
        $self->installISR(intr, gpio, level, mraa_java_isr_callback, runnable);
    }
}

JAVA_JNI_LOADLIBRARY(javaupm_bmm150)

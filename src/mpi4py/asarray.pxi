#---------------------------------------------------------------------

cdef inline object newarray_int(int n, int **p):
     if n < 0: n = 0
     cdef int *array = NULL
     cdef object ob = allocate(n*sizeof(int), <void**>&array)
     p[0] = array
     return ob

cdef inline object newarray_int3(int n, int (**p)[3]):
     if n < 0: n = 0
     cdef int (*array)[3] # = NULL ## XXX
     cdef object ob = allocate(n*sizeof(int[3]), <void**>&array)
     p[0] = array
     return ob

#---------------------------------------------------------------------

cdef inline object asarray_int(object sequence, int **p, Py_ssize_t size):
     cdef int *array = NULL
     cdef Py_ssize_t i = 0, n = len(sequence)
     if size > 0: assert n == size, "expecting %d items, got %d" % (size, n)
     cdef object ob = allocate(n*sizeof(int), <void**>&array)
     for i from 0 <= i < n: array[i] = sequence[i]
     p[0] = array
     return ob

cdef inline object asarray_Aint(object sequence, MPI_Aint **p, Py_ssize_t size):
     cdef MPI_Aint *array = NULL
     cdef Py_ssize_t i = 0, n = len(sequence)
     if size > 0: assert n == size, "expecting %d items, got %d" % (size, n)
     cdef object ob = allocate(n*sizeof(MPI_Aint), <void**>&array)
     for i from 0 <= i < n: array[i] = sequence[i]
     p[0] = array
     return ob

cdef inline object asarray_Datatype(object sequence, MPI_Datatype **p, Py_ssize_t size):
     cdef MPI_Datatype *array = NULL
     cdef Py_ssize_t i = 0, n = len(sequence)
     if size >= 0: assert n == size, "expecting %d items, got %d" % (size, n)
     cdef object ob = allocate(n*sizeof(MPI_Datatype), <void**>&array)
     for i from 0 <= i < n: array[i] = (<Datatype?>sequence[i]).ob_mpi
     p[0] = array
     return ob

cdef inline object asarray_Request(object sequence, MPI_Request **p, Py_ssize_t size):
     cdef MPI_Request *array = NULL
     cdef Py_ssize_t i = 0, n = len(sequence)
     if size >= 0: assert n == size, "expecting %d items, got %d" % (size, n)
     cdef object ob = allocate(n*sizeof(MPI_Request), <void**>&array)
     for i from 0 <= i < n: array[i] = (<Request?>sequence[i]).ob_mpi
     p[0] = array
     return ob

cdef inline object restore_Request(object sequence, MPI_Request **p, Py_ssize_t size):
     cdef Py_ssize_t i
     cdef MPI_Request *array = p[0]
     for i from 0 <= i < size: (<Request?>sequence[i]).ob_mpi = array[i]
     return None

cdef inline object asarray_Status(object sequence, MPI_Status **p, Py_ssize_t n):
     if sequence is None: return None
     cdef MPI_Status *array = NULL
     cdef object ob = allocate(n*sizeof(MPI_Status), <void**>&array)
     p[0] = array
     return ob

cdef inline object restore_Status(object sequence, MPI_Status **p, Py_ssize_t n):
     if sequence is None: return None
     cdef Py_ssize_t i = 0, m = n - len(sequence)
     for i from 0 <= i < m: sequence.append(Status())
     cdef MPI_Status *array = p[0]
     for i from 0 <= i < n: (<Status?>sequence[i]).ob_mpi = array[i]
     return None

#---------------------------------------------------------------------

cdef extern from "Python.h":
     char *PyString_AsString(object)

cdef inline object asarray_argv(sequence, char ***p):
     cdef Py_ssize_t i = 0, n = len(sequence)
     cdef char** array = NULL
     cdef object ob = allocate((n+1)*sizeof(char*), <void**>&array)
     for i from 0 <= i < n: array[i] = PyString_AsString(sequence[i])
     array[n] = NULL
     p[0] = array
     return ob

#---------------------------------------------------------------------

#ifndef _TIMES_H
#define _TIMES_H

#if defined(_WIN32) || defined(__MINGW32__)

	#include "CompuCell3D/steppables/PDESolvers/MyTime.h"

	#include <time.h>

	// Returns information about a process' consumption of processor time
	struct tms
	  {
		// Total processor time used in executing its instructions
		clock_t tms_utime;
		// Total processor time used
		clock_t tms_stime;
		// Sum of tms_utime and tms_cutime of all terminated child processes
		clock_t tms_cutime;
		// Like tms_cutime but for tms_stime
		clock_t tms_cstime;
	  };

	// Stores information about the processor time in the passed calling process
	clock_t times(struct tms *_buffer) {
		_buffer->tms_utime = clock();
		_buffer->tms_stime = 0;
		_buffer->tms_cstime = 0;
		_buffer->tms_cutime = 0;
		return _buffer->tms_utime;
	}

#else
	#include <sys/times.h>
#endif

#endif

#include "nscore.h"
#include "nsUniversalDetector.h"
extern "C" {
#include "run-detector.h"
}

class Detector: public nsUniversalDetector {
    public:
	Detector() {};
	virtual ~Detector() {}
	const char *getresult() { return mDetectedCharset; }
	virtual void Reset() { this->nsUniversalDetector::Reset(); }
    protected:
	virtual void Report(const char* aCharset) { mDetectedCharset = aCharset; }
};

extern "C" const char *
run_detector (const char * buf, int len)
{
    const char * r;
    Detector *det = new Detector;
    det->HandleData (buf, len);
    det->DataEnd ();
    r = det->getresult();
    delete det;
    return r;
}


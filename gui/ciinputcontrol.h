
#include <string>

class IInputControl
{
    public:
        virtual ~IInputControl() {}
        virtual void InsertText(const string text) = 0;
};
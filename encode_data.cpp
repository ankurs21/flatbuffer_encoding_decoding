#include "client_generated.h"
#include <fstream>

int main() {
    flatbuffers::FlatBufferBuilder builder;

    // Create a Person object
    auto personName = builder.CreateString("John");
    int personAge = 30;
    float personWeight = 75.5;
    auto personGender = builder.CreateString("Male");
    auto person = MyNamespace::CreatePerson(builder, personName, personAge, personWeight, personGender);

    // Create a Client union as a Person
    auto clientPerson = MyNamespace::CreateClient(builder, MyNamespace::Client_Person, person.Union());

    builder.Finish(clientPerson); // Finish with a Person for this example

    // Access the serialized data and its size
    const uint8_t* serializedData = builder.GetBufferPointer();
    int serializedSize = builder.GetSize();

    // Save the serialized data to a binary file
    std::ofstream outFile("person_data.bin", std::ios::out | std::ios::binary);
    outFile.write(reinterpret_cast<const char*>(serializedData), serializedSize);
    outFile.close();

    return 0;
}

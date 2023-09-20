#include "../generated/client_generated.h"
#include <iostream>
#include <fstream>

using namespace MyData;

int main() {
    flatbuffers::FlatBufferBuilder builder;

    std::ofstream outfile("clients.bin", std::ios::binary);
    // Create a Person
    auto name = builder.CreateString("Alice");
    auto gender = builder.CreateString("female");
    auto person = MyData::CreatePerson(builder, name, 30, 65.5, gender);

    // Create a Group
    auto group_name = builder.CreateString("Family");
    std::vector<flatbuffers::Offset<flatbuffers::String>> names;
    names.push_back(builder.CreateString("Alice"));
    names.push_back(builder.CreateString("Bob"));
    auto group = MyData::CreateGroup(builder, group_name, 27.5, 70.3, builder.CreateVector(names));

    auto personUnionType = ClientData::ClientData_Person;
    auto clientPerson = CreateClient(builder, personUnionType, person.Union());
    
    builder.Finish(clientPerson);

    const uint8_t* person1 = builder.GetBufferPointer();
    const size_t person1Size = builder.GetSize();

    //builder.Clear();

    auto groupUnionType = ClientData::ClientData_Group;
    auto clientGroup = CreateClient(builder, groupUnionType, group.Union());

    builder.Finish(clientGroup);


    const uint8_t* group1 = builder.GetBufferPointer();
    const size_t group1Size = builder.GetSize();


    // Write data to binary file
    outfile.write(reinterpret_cast<const char*>(group1), group1Size);
    outfile.write(reinterpret_cast<const char*>(person1), person1Size);

    outfile.close();

    std::cout << "Data encoded and written to 'clients.bin'" << std::endl;

    return 0;
}


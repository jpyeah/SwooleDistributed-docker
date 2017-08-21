<?php

namespace ProtobufCompilerTest\Descriptor;

use Protobuf\Configuration;
use Protobuf\WriteContext;
use Protobuf\Stream;

use ProtobufCompilerTest\TestCase;
use ProtobufCompilerTest\Protos\AddressBook;

/**
 * @group functional
 */
class ToStreamTest extends TestCase
{
    protected function setUp()
    {
        $this->markTestIncompleteIfProtoClassNotFound();

        parent::setUp();
    }

    public function testAddressBookToStream()
    {
        $config  = $this->getMock(Configuration::CLASS);
        $stream  = $this->getMock(Stream::CLASS, [], [], '', false);
        $context = $this->getMock(WriteContext::CLASS, [], [], '', false);
        $message = $this->getMockBuilder(AddressBook::CLASS)
            ->setMethods(['writeTo'])
            ->getMock();

        $stream->expects($this->once())
            ->method('seek')
            ->with($this->equalTo(0));

        $config->expects($this->once())
            ->method('createWriteContext')
            ->willReturn($context);

        $context->expects($this->once())
            ->method('getStream')
            ->willReturn($stream);

        $message->expects($this->once())
            ->method('writeTo')
            ->with($this->equalTo($context));

        $this->assertSame($stream, $message->toStream($config));
    }
}

import rpisysfsgpio;
import std.stdio;
import core.thread;

void main()
{
    // Sample LED blinking.
    RpiSysFsGpio gpio = new RpiSysFsGpio();
    int pin = 7, i;

    if (!gpio.isExported(pin)) {
        gpio.exportPin(pin);
    }

    writeln("Blinking...");

    gpio.direction(
        pin,
        gpio.IN
    );

    for (i = 0; i < 10; i++) {
        gpio.write(
            pin,
            gpio.HIGH
        );
        Thread.sleep(dur!("seconds")(1));
        gpio.write(
            pin,
            gpio.LOW
        );
        Thread.sleep(dur!("seconds")(1));
    }

    writeln("Done.");

    gpio.write(
        pin,
        gpio.LOW
    );

    gpio.unexportPin(pin);
}

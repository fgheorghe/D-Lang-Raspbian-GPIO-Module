/**
 * Module for managing Raspberry PI GPIO PINs, using Raspbian's SYSFS.
 * Based on: http://elinux.org/RPi_GPIO_Code_Samples
 */
module rpisysfsgpio;

import std.string;
import std.file;
import std.conv;

// TODO: Improve error handling and add PWM support.
class RpiSysFsGpio {
    /** Define file system paths for exporting, unexporting, setting direction for, and writing values to pins. */
    const string sysfsExportPath = "/sys/class/gpio/export";
    const string sysfsUnexportPath = "/sys/class/gpio/unexport";
    const string sysfsDirectionPath = "/sys/class/gpio/gpio%d/direction";
    const string sysfsValuePath = "/sys/class/gpio/gpio%d/value";

    /** Convenience constants for setting pin direction. */
    const int IN = 0;
    const int OUT = 1;

    /** Convenience constants for setting pin state values. */
    const int LOW = 0; // Off.
    const int HIGH = 1; // On.

    // Method used for writing to export and unexport files.
    private void writeToSysfsFile(string path, int pin) {
        append(
            path,
            format("%d\n", pin)
        );
    }

    // Convenience method for writing to value files.
    private void writeToSysfsValueFile(string path, int pin, int value) {
        append(
            format(path, pin),
            format("%d\n", value)
        );
    }

    // Convenience method for writing to direction files.
    private void writeToSysfsDirectionFile(string path, int pin, int value) {
        append(
            format(path, pin),
            format("%s\n", value == 1 ? "in" : "out")
        );
    }

    /**
     * Method used for verifying if a pin has been exported, by checking if the value file exists for a given pin.
     * @param pin Pin to verify.
     * @return true or false if it has been or not.
     */
    bool isExported(int pin) {
        return exists(format(this.sysfsValuePath, pin));
    }

    /**
     * Function used for exporting a pin - making it accessible that is.
     * @param pin GPIO pin number.
     */
    void exportPin(int pin) {
        this.writeToSysfsFile(
            this.sysfsExportPath,
            pin
        );
    }

    /**
     * Function used for unexporting a pin.
     * @param pin GPIO pin number.
     */
    void unexportPin(int pin) {
        this.writeToSysfsFile(
            this.sysfsUnexportPath,
            pin
        );
    }

    /**
     * Function used for setting a pin direction.
     *
     * NOTE: Errors such as:
     * std.file.FileException@std/file.d(x): /sys/class/gpio/gpio1/direction: No such file or directory
     * mean a given pin has not been exported - in this instance example, pin 1.
     *
     * @param pin GPIO pin number.
     * @param dir Direction: 0 - IN (read), 1 - OUT (write).
     */
    void direction(int pin, int dir) {
        this.writeToSysfsDirectionFile(
            this.sysfsDirectionPath,
            pin,
            dir
        );
    }

    /**
     * Function used for reading a pin value.
     *
     * NOTE: Errors such as:
     * std.file.FileException@std/file.d(x): /sys/class/gpio/gpio1/value: No such file or directory
     * mean a given pin has not been exported - in this instance example, pin 1.
     *
     * @param pin GPIO pin number.
     * @return pin value (0 = Low, 1 = High).
     */
    int read(int pin) {
        int value;
        value = to!int(readText(
            format(this.sysfsValuePath, pin)
        ).stripRight());
        return value;
    }

    /**
     * Function used for writing a state to a pin.
     *
     * NOTE: Errors such as:
     * std.file.FileException@std/file.d(x): /sys/class/gpio/gpio1/value: No such file or directory
     * mean a given pin has not been exported - in this instance example, pin 1.
     *
     * @param pin GPIO pin number.
     * @param value Value to write (0 = Low, 1 = High).
     */
    void write(int pin, int value) {
        this.writeToSysfsValueFile(
            this.sysfsValuePath,
            pin,
            value
        );
    }
}
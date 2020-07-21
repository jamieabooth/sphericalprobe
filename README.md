# Spherical Probe

The following code accompanies the paper, 'Breakdown of continuum models for spherical probe adhesion tests on micropatterned surfaces' by Simon Bettscheider, Dan Yu, Kimberly L. Foster, Robert M. McMeeking, Eduard Arzt, René Hensel, and Jamie A. Booth (In prep.) DOI: TBD. The figure below shows a schematic representation of components of the model.

![Schematic](/schematic.png)

The main script ('SphericalProbe_ExtractFibrilStrength.m') serves to extract a local measure of the adhesive strength of a fibrillar structure from a spherical probe adhesion test of a bioinspired micropatterned adhesive surface. It takes as its input the saturation pull-off force, the geometric properties of the fibril and array, and the material properties of the component material. It is valid for cylindrical vertically-oriented fibrils (independent of the tip-geometry) arranged in a hexangonal- or square-packed array, on a thick backing layer of the same component material. It outputs the fibril strain at detachment, the fibril detachment force, and the effective work of adhesion of the fibrillar interface. It should be ensured that the pull-off force is measured in the saturation regime with respect to preload, and that the array extends beyond the contact in this regime.

## Installation requirements

The code runs on MATLAB. Compatibility with all versions of MATLAB has not been tested.

## Set-up

...

## Running

...  The following inputs should be provided using a consistent system of units for length and force e.g. if dimensions are provided in mm and the pull-off force in mN, then the Young''s modulus should be provided in mN/(mm^2)

## Authors

...

## Contact

...


## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details

## Acknowledgments

...


MatrixTransform {
  DataVariance STATIC
  name "Scene Root"
  nodeMask 0xffffffff
  cullingActive TRUE
  StateSet {
    UniqueID StateSet_0
    rendering_hint DEFAULT_BIN
    renderBinMode INHERIT
    GL_LIGHTING ON
  }
  referenceFrame RELATIVE
  Matrix {
    1 0 0 0
    0 1 0 0
    0 0 1 0
    0 0 0 1
  }
  num_children 2
  Group {
    DataVariance STATIC
    name "Group001"
    nodeMask 0xffffffff
    cullingActive TRUE
    num_children 2
    Group {
      DataVariance STATIC
      name "Pyramid001"
      nodeMask 0xffffffff
      cullingActive TRUE
      num_children 1
      Geode {
        UniqueID Geode_1
        DataVariance STATIC
        name "Pyramid001-GEODE"
        nodeMask 0xffffffff
        cullingActive TRUE
        num_drawables 1
        Geometry {
          name "01 - Default"
          StateSet {
            UniqueID StateSet_2
            name "01 - Default"
            rendering_hint DEFAULT_BIN
            renderBinMode INHERIT
            GL_CULL_FACE ON
            GL_LIGHTING ON
            GL_NORMALIZE ON
            Material {
              ColorMode OFF
              ambientColor 0.588235 0.588235 0.588235 1
              diffuseColor 1 1 1 1
              specularColor 0 0 0 1
              emissionColor 0 0 0 1
              shininess 0
            }
            textureUnit 0 {
              GL_TEXTURE_2D ON
              Texture2D {
                UniqueID Texture2D_3
                file "D:\\Documents\\3dsMax\\sceneassets\\images\\BARK5.jpg"
                wrap_s REPEAT
                wrap_t REPEAT
                wrap_r CLAMP_TO_EDGE
                min_filter LINEAR_MIPMAP_LINEAR
                mag_filter LINEAR
                maxAnisotropy 1
                borderColor 0 0 0 0
                borderWidth 0
                useHardwareMipMapGeneration TRUE
                unRefImageDataAfterApply TRUE
                internalFormatMode USE_IMAGE_DATA_FORMAT
                resizeNonPowerOfTwo FALSE
                shadowComparison FALSE
                shadowCompareFunc GL_LEQUAL
                shadowTextureMode GL_LUMINANCE
              }
            }
          }
          useDisplayList TRUE
          useVertexBufferObjects FALSE
          PrimitiveSets 2
          {
            DrawElementsUShort TRIANGLE_STRIP 5
            {
              12 16 13 15 14 
            }
            DrawArrays TRIANGLES 0 15
          }
          VertexArray Vec3Array 17
          {
            1.9595 -0.981123 0.530521
            1.48629 -1.1557 0.000127018
            2.11042 -1.4624 0.000127018
            1.9595 -0.981123 0.530521
            2.11042 -1.4624 0.000127018
            2.4327 -0.80654 0.000127018
            1.9595 -0.981123 0.530521
            2.4327 -0.80654 0.000127018
            1.80858 -0.499847 0.000127018
            1.9595 -0.981123 0.530521
            1.80858 -0.499847 0.000127018
            1.48629 -1.1557 0.000127018
            1.48629 -1.1557 0.000127018
            1.9595 -0.981123 0.000127018
            2.11042 -1.4624 0.000127018
            2.4327 -0.80654 0.000127018
            1.80858 -0.499847 0.000127018
          }
          NormalBinding PER_VERTEX
          NormalArray Vec3Array 17
          {
            -0.363189 -0.739093 0.567305
            -0.363189 -0.739093 0.567305
            -0.363189 -0.739093 0.567305
            0.750587 -0.368837 0.54825
            0.750587 -0.368837 0.54825
            0.750587 -0.368837 0.54825
            0.363189 0.739093 0.567305
            0.363189 0.739093 0.567305
            0.363189 0.739093 0.567305
            -0.750587 0.368837 0.54825
            -0.750587 0.368837 0.54825
            -0.750587 0.368837 0.54825
            0 0 -1
            0 0 -1
            0 0 -1
            0 0 -1
            0 0 -1
          }
          TexCoordArray 0 Vec2Array 17
          {
            0.5 1
            0 0
            1 0
            0.5 1
            0.0241935 0
            1.02419 0
            0.5 1
            0 0
            1 0
            0.5 1
            0.0241935 0
            1.02419 0
            0 1
            0.5 0.5
            1 1
            1 0
            0 0
          }
        }
      }
    }
    Group {
      DataVariance STATIC
      name "Box001"
      nodeMask 0xffffffff
      cullingActive TRUE
      num_children 1
      Geode {
        UniqueID Geode_4
        DataVariance STATIC
        name "Box001-GEODE"
        nodeMask 0xffffffff
        cullingActive TRUE
        num_drawables 1
        Geometry {
          useDisplayList TRUE
          useVertexBufferObjects FALSE
          PrimitiveSets 6
          {
            DrawElementsUShort TRIANGLE_STRIP 4
            {
              1 2 0 3 
            }
            DrawElementsUShort TRIANGLE_STRIP 4
            {
              7 4 6 5 
            }
            DrawElementsUShort TRIANGLE_STRIP 4
            {
              23 20 22 21 
            }
            DrawElementsUShort TRIANGLE_STRIP 4
            {
              19 16 18 17 
            }
            DrawElementsUShort TRIANGLE_STRIP 4
            {
              13 14 12 15 
            }
            DrawElementsUShort TRIANGLE_STRIP 4
            {
              9 10 8 11 
            }
          }
          VertexArray Vec3Array 24
          {
            -0.382514 0.0121464 1.56628e-010
            -0.00304687 0.784366 1.56628e-010
            0.737437 0.420493 1.56628e-010
            0.35797 -0.351727 1.56628e-010
            -0.382514 0.0121464 0.495035
            0.35797 -0.351727 0.495035
            0.737437 0.420493 0.495035
            -0.00304687 0.784366 0.495035
            -0.382514 0.0121464 1.56628e-010
            0.35797 -0.351727 1.56628e-010
            0.35797 -0.351727 0.495035
            -0.382514 0.0121464 0.495035
            0.35797 -0.351727 1.56628e-010
            0.737437 0.420493 1.56628e-010
            0.737437 0.420493 0.495035
            0.35797 -0.351727 0.495035
            0.737437 0.420493 1.56628e-010
            -0.00304687 0.784366 1.56628e-010
            -0.00304687 0.784366 0.495035
            0.737437 0.420493 0.495035
            -0.00304687 0.784366 1.56628e-010
            -0.382514 0.0121464 1.56628e-010
            -0.382514 0.0121464 0.495035
            -0.00304687 0.784366 0.495035
          }
          NormalBinding PER_VERTEX
          NormalArray Vec3Array 24
          {
            0 0 -1
            0 0 -1
            0 0 -1
            0 0 -1
            0 0 1
            0 0 1
            0 0 1
            0 0 1
            -0.441027 -0.897494 0
            -0.441027 -0.897494 0
            -0.441027 -0.897494 0
            -0.441027 -0.897494 0
            0.897494 -0.441027 0
            0.897494 -0.441027 0
            0.897494 -0.441027 0
            0.897494 -0.441027 0
            0.441027 0.897494 0
            0.441027 0.897494 0
            0.441027 0.897494 0
            0.441027 0.897494 0
            -0.897494 0.441027 0
            -0.897494 0.441027 0
            -0.897494 0.441027 0
            -0.897494 0.441027 0
          }
          ColorBinding OVERALL
          ColorArray Vec4Array 1
          {
            0.0235294 0.52549 0.0235294 1
          }
        }
      }
    }
  }
  Group {
    DataVariance STATIC
    name "Box002"
    nodeMask 0xffffffff
    cullingActive TRUE
    num_children 1
    Geode {
      UniqueID Geode_5
      DataVariance STATIC
      name "Box002-GEODE"
      nodeMask 0xffffffff
      cullingActive TRUE
      num_drawables 1
      Geometry {
        useDisplayList TRUE
        useVertexBufferObjects FALSE
        PrimitiveSets 6
        {
          DrawElementsUShort TRIANGLE_STRIP 4
          {
            1 2 0 3 
          }
          DrawElementsUShort TRIANGLE_STRIP 4
          {
            7 4 6 5 
          }
          DrawElementsUShort TRIANGLE_STRIP 4
          {
            23 20 22 21 
          }
          DrawElementsUShort TRIANGLE_STRIP 4
          {
            19 16 18 17 
          }
          DrawElementsUShort TRIANGLE_STRIP 4
          {
            13 14 12 15 
          }
          DrawElementsUShort TRIANGLE_STRIP 4
          {
            9 10 8 11 
          }
        }
        VertexArray Vec3Array 24
        {
          2.18376 0.130019 0
          2.48525 0.743564 0
          3.05648 0.462862 0
          2.75499 -0.150683 0
          2.18376 0.130019 0.436102
          2.75499 -0.150683 0.436102
          3.05648 0.462862 0.436102
          2.48525 0.743564 0.436102
          2.18376 0.130019 0
          2.75499 -0.150683 0
          2.75499 -0.150683 0.436102
          2.18376 0.130019 0.436102
          2.75499 -0.150683 0
          3.05648 0.462862 0
          3.05648 0.462862 0.436102
          2.75499 -0.150683 0.436102
          3.05648 0.462862 0
          2.48525 0.743564 0
          2.48525 0.743564 0.436102
          3.05648 0.462862 0.436102
          2.48525 0.743564 0
          2.18376 0.130019 0
          2.18376 0.130019 0.436102
          2.48525 0.743564 0.436102
        }
        NormalBinding PER_VERTEX
        NormalArray Vec3Array 24
        {
          0 0 -1
          0 0 -1
          0 0 -1
          0 0 -1
          0 0 1
          0 0 1
          0 0 1
          0 0 1
          -0.441027 -0.897494 0
          -0.441027 -0.897494 0
          -0.441027 -0.897494 0
          -0.441027 -0.897494 0
          0.897494 -0.441027 0
          0.897494 -0.441027 0
          0.897494 -0.441027 0
          0.897494 -0.441027 0
          0.441027 0.897494 0
          0.441027 0.897494 0
          0.441027 0.897494 0
          0.441027 0.897494 0
          -0.897494 0.441027 0
          -0.897494 0.441027 0
          -0.897494 0.441027 0
          -0.897494 0.441027 0
        }
        ColorBinding OVERALL
        ColorArray Vec4Array 1
        {
          0.776471 0.878431 0.341176 1
        }
      }
    }
  }
}

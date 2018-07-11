-- [[
-- @cond ___LICENSE___
--
-- Copyright (c) 2016-2018 Zefiros Software.
--
-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:
--
-- The above copyright notice and this permission notice shall be included in
-- all copies or substantial portions of the Software.
--
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
-- THE SOFTWARE.
--
-- @endcond
-- ]]
    local vectorextensionmapping = {
        sse2 = {"SSE2", "SIMDPP_ARCH_X86_SSE2"},
        sse3 = {"SSE3", "SIMDPP_ARCH_X86_SSE3"},
        ssse3 = {"SSSE3", "SIMDPP_ARCH_X86_SSSE3"},
        ["sse4.1"] = {"SSE4.1", "SIMDPP_ARCH_X86_SSE4_1"},
        avx = {"AVX", "SIMDPP_ARCH_X86_AVX"},
        avx2 = {"AVX2", "SIMDPP_ARCH_X86_AVX2"}
    }

    local function setVectorExtensions()
        ve = zpm.setting("simd"):lower()

        if ve ~= nil and vectorextensionmapping[ve] ~= nil then
            ve = vectorextensionmapping[ve]
            veset, vedef = ve[1], ve[2]
            if veset:match("SSE") then
                defines "SIMDPP_HAS_SSE_SUPPORT"
            end

            if veset:match("AVX") then
                defines "SIMDPP_HAS_AVX_SUPPORT"
            end

            vectorextensions(veset)

            defines(vedef)
        end
    end

    project "simdpp"
        kind "StaticLib"

        files {
            "simdpp/**.h"
        }

        setVectorExtensions()

        if zpm.setting("withTestFiles") then
            defines "SIMDPP_EMIT_DISPATCHER"
            files {
                "test/**.cc"
            }

            includedirs "test"
        end

        includedirs "."

        zpm.export(function()
            includedirs "."

            setVectorExtensions()

            filter {}
        end)

        filter {}

// Generated by Apple Swift version 3.1 (swiftlang-802.0.53 clang-802.0.42)
#pragma clang diagnostic push

#if defined(__has_include) && __has_include(<swift/objc-prologue.h>)
# include <swift/objc-prologue.h>
#endif

#pragma clang diagnostic ignored "-Wauto-import"
#include <objc/NSObject.h>
#include <stdint.h>
#include <stddef.h>
#include <stdbool.h>

#if !defined(SWIFT_TYPEDEFS)
# define SWIFT_TYPEDEFS 1
# if defined(__has_include) && __has_include(<uchar.h>)
#  include <uchar.h>
# elif !defined(__cplusplus) || __cplusplus < 201103L
typedef uint_least16_t char16_t;
typedef uint_least32_t char32_t;
# endif
typedef float swift_float2  __attribute__((__ext_vector_type__(2)));
typedef float swift_float3  __attribute__((__ext_vector_type__(3)));
typedef float swift_float4  __attribute__((__ext_vector_type__(4)));
typedef double swift_double2  __attribute__((__ext_vector_type__(2)));
typedef double swift_double3  __attribute__((__ext_vector_type__(3)));
typedef double swift_double4  __attribute__((__ext_vector_type__(4)));
typedef int swift_int2  __attribute__((__ext_vector_type__(2)));
typedef int swift_int3  __attribute__((__ext_vector_type__(3)));
typedef int swift_int4  __attribute__((__ext_vector_type__(4)));
typedef unsigned int swift_uint2  __attribute__((__ext_vector_type__(2)));
typedef unsigned int swift_uint3  __attribute__((__ext_vector_type__(3)));
typedef unsigned int swift_uint4  __attribute__((__ext_vector_type__(4)));
#endif

#if !defined(SWIFT_PASTE)
# define SWIFT_PASTE_HELPER(x, y) x##y
# define SWIFT_PASTE(x, y) SWIFT_PASTE_HELPER(x, y)
#endif
#if !defined(SWIFT_METATYPE)
# define SWIFT_METATYPE(X) Class
#endif
#if !defined(SWIFT_CLASS_PROPERTY)
# if __has_feature(objc_class_property)
#  define SWIFT_CLASS_PROPERTY(...) __VA_ARGS__
# else
#  define SWIFT_CLASS_PROPERTY(...)
# endif
#endif

#if defined(__has_attribute) && __has_attribute(objc_runtime_name)
# define SWIFT_RUNTIME_NAME(X) __attribute__((objc_runtime_name(X)))
#else
# define SWIFT_RUNTIME_NAME(X)
#endif
#if defined(__has_attribute) && __has_attribute(swift_name)
# define SWIFT_COMPILE_NAME(X) __attribute__((swift_name(X)))
#else
# define SWIFT_COMPILE_NAME(X)
#endif
#if defined(__has_attribute) && __has_attribute(objc_method_family)
# define SWIFT_METHOD_FAMILY(X) __attribute__((objc_method_family(X)))
#else
# define SWIFT_METHOD_FAMILY(X)
#endif
#if defined(__has_attribute) && __has_attribute(noescape)
# define SWIFT_NOESCAPE __attribute__((noescape))
#else
# define SWIFT_NOESCAPE
#endif
#if defined(__has_attribute) && __has_attribute(warn_unused_result)
# define SWIFT_WARN_UNUSED_RESULT __attribute__((warn_unused_result))
#else
# define SWIFT_WARN_UNUSED_RESULT
#endif
#if !defined(SWIFT_CLASS_EXTRA)
# define SWIFT_CLASS_EXTRA
#endif
#if !defined(SWIFT_PROTOCOL_EXTRA)
# define SWIFT_PROTOCOL_EXTRA
#endif
#if !defined(SWIFT_ENUM_EXTRA)
# define SWIFT_ENUM_EXTRA
#endif
#if !defined(SWIFT_CLASS)
# if defined(__has_attribute) && __has_attribute(objc_subclassing_restricted)
#  define SWIFT_CLASS(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) __attribute__((objc_subclassing_restricted)) SWIFT_CLASS_EXTRA
#  define SWIFT_CLASS_NAMED(SWIFT_NAME) __attribute__((objc_subclassing_restricted)) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
# else
#  define SWIFT_CLASS(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
#  define SWIFT_CLASS_NAMED(SWIFT_NAME) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
# endif
#endif

#if !defined(SWIFT_PROTOCOL)
# define SWIFT_PROTOCOL(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) SWIFT_PROTOCOL_EXTRA
# define SWIFT_PROTOCOL_NAMED(SWIFT_NAME) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_PROTOCOL_EXTRA
#endif

#if !defined(SWIFT_EXTENSION)
# define SWIFT_EXTENSION(M) SWIFT_PASTE(M##_Swift_, __LINE__)
#endif

#if !defined(OBJC_DESIGNATED_INITIALIZER)
# if defined(__has_attribute) && __has_attribute(objc_designated_initializer)
#  define OBJC_DESIGNATED_INITIALIZER __attribute__((objc_designated_initializer))
# else
#  define OBJC_DESIGNATED_INITIALIZER
# endif
#endif
#if !defined(SWIFT_ENUM)
# define SWIFT_ENUM(_type, _name) enum _name : _type _name; enum SWIFT_ENUM_EXTRA _name : _type
# if defined(__has_feature) && __has_feature(generalized_swift_name)
#  define SWIFT_ENUM_NAMED(_type, _name, SWIFT_NAME) enum _name : _type _name SWIFT_COMPILE_NAME(SWIFT_NAME); enum SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_ENUM_EXTRA _name : _type
# else
#  define SWIFT_ENUM_NAMED(_type, _name, SWIFT_NAME) SWIFT_ENUM(_type, _name)
# endif
#endif
#if !defined(SWIFT_UNAVAILABLE)
# define SWIFT_UNAVAILABLE __attribute__((unavailable))
#endif
#if !defined(SWIFT_UNAVAILABLE_MSG)
# define SWIFT_UNAVAILABLE_MSG(msg) __attribute__((unavailable(msg)))
#endif
#if !defined(SWIFT_AVAILABILITY)
# define SWIFT_AVAILABILITY(plat, ...) __attribute__((availability(plat, __VA_ARGS__)))
#endif
#if !defined(SWIFT_DEPRECATED)
# define SWIFT_DEPRECATED __attribute__((deprecated))
#endif
#if !defined(SWIFT_DEPRECATED_MSG)
# define SWIFT_DEPRECATED_MSG(...) __attribute__((deprecated(__VA_ARGS__)))
#endif
#if defined(__has_feature) && __has_feature(modules)
@import ObjectiveC;
#endif

#pragma clang diagnostic ignored "-Wproperty-attribute-mismatch"
#pragma clang diagnostic ignored "-Wduplicate-method-arg"
@class Chord;
@protocol AudioListener;

SWIFT_CLASS("_TtC20FretXAudioProcessing5Audio")
@interface Audio : NSObject
SWIFT_CLASS_PROPERTY(@property (nonatomic, class, readonly, strong) Audio * _Nonnull shared;)
+ (Audio * _Nonnull)shared SWIFT_WARN_UNUSED_RESULT;
- (nonnull instancetype)init SWIFT_UNAVAILABLE;
- (void)start;
- (void)stop;
- (void)releaseAudio;
- (void)reInit;
- (void)optimizeForTuner;
- (void)optimizeForChord;
- (float)getPitch SWIFT_WARN_UNUSED_RESULT;
- (float)getProgress SWIFT_WARN_UNUSED_RESULT;
- (void)setTargetChordWithChord:(Chord * _Nonnull)chord;
- (void)setTargetChordsWithChords:(NSArray<Chord *> * _Nonnull)chords;
- (void)setAudioListenerWithListener:(id <AudioListener> _Nonnull)listener;
- (void)updateTimer;
- (void)startListening;
- (void)stopListening;
@end

@class ParameterAnalyzer;
@class AudioData;

SWIFT_CLASS("_TtC20FretXAudioProcessing13AudioAnalyzer")
@interface AudioAnalyzer : NSObject
- (void)addParameterAnalyzerWithPa:(ParameterAnalyzer * _Nonnull)pa;
- (void)removeParameterAnalyzerAtIndex:(NSInteger)index;
- (void)processWithAudioData:(AudioData * _Nonnull)audioData;
- (void)enable;
- (void)disable;
- (BOOL)isEnabled SWIFT_WARN_UNUSED_RESULT;
+ (float)medianWithM:(NSArray<NSNumber *> * _Nonnull)m SWIFT_WARN_UNUSED_RESULT;
+ (float)findMaxValueWithArray:(NSArray<NSNumber *> * _Nonnull)array beginIndex:(NSInteger)beginIndex endIndex:(NSInteger)endIndex SWIFT_WARN_UNUSED_RESULT;
+ (NSInteger)findMaxIndexWithArray:(NSArray<NSNumber *> * _Nonnull)array SWIFT_WARN_UNUSED_RESULT;
- (nonnull instancetype)init SWIFT_UNAVAILABLE;
@end


SWIFT_CLASS("_TtC20FretXAudioProcessing9AudioData")
@interface AudioData : NSObject
- (nonnull instancetype)initWithSampleRate:(float)sampleRate audioBuffer:(NSArray<NSNumber *> * _Nonnull)audioBuffer OBJC_DESIGNATED_INITIALIZER;
- (void)normalize;
- (float)getSignalPower SWIFT_WARN_UNUSED_RESULT;
- (nonnull instancetype)init SWIFT_UNAVAILABLE;
@end


SWIFT_PROTOCOL("_TtP20FretXAudioProcessing13AudioListener_")
@protocol AudioListener
- (void)onProgress;
- (void)onLowVolume;
- (void)onHighVolume;
- (void)onTimeout;
@end


SWIFT_CLASS("_TtC20FretXAudioProcessing15AudioProcessing")
@interface AudioProcessing : NSObject
- (nonnull instancetype)initWithBufferSize:(double)bufferSize OBJC_DESIGNATED_INITIALIZER;
- (BOOL)isInitialized SWIFT_WARN_UNUSED_RESULT;
- (void)startRecording;
- (void)stopRecording;
- (Chord * _Nonnull)getChord SWIFT_WARN_UNUSED_RESULT;
- (void)setTargetChordsWithChords:(NSArray<Chord *> * _Nonnull)chords;
- (NSArray<Chord *> * _Nonnull)getTargetChords SWIFT_WARN_UNUSED_RESULT;
- (float)getPitch SWIFT_WARN_UNUSED_RESULT;
- (nonnull instancetype)init SWIFT_UNAVAILABLE;
@end

@class FretboardPosition;

SWIFT_CLASS("_TtC20FretXAudioProcessing5Chord")
@interface Chord : NSObject
SWIFT_CLASS_PROPERTY(@property (nonatomic, class, readonly, copy) NSArray<NSString *> * _Nonnull ALL_ROOT_NOTES;)
+ (NSArray<NSString *> * _Nonnull)ALL_ROOT_NOTES SWIFT_WARN_UNUSED_RESULT;
SWIFT_CLASS_PROPERTY(@property (nonatomic, class, readonly, copy) NSArray<NSString *> * _Nonnull ALL_CHORD_TYPES;)
+ (NSArray<NSString *> * _Nonnull)ALL_CHORD_TYPES SWIFT_WARN_UNUSED_RESULT;
SWIFT_CLASS_PROPERTY(@property (nonatomic, class, readonly, copy) NSArray<NSString *> * _Nonnull NOISE_CLASS_ROOT_AND_TYPE;)
+ (NSArray<NSString *> * _Nonnull)NOISE_CLASS_ROOT_AND_TYPE SWIFT_WARN_UNUSED_RESULT;
@property (nonatomic, readonly, copy) NSString * _Nonnull name;
- (nonnull instancetype)initWithRoot:(NSString * _Nonnull)root type:(NSString * _Nonnull)type OBJC_DESIGNATED_INITIALIZER;
- (NSArray<FretboardPosition *> * _Nonnull)getFingering SWIFT_WARN_UNUSED_RESULT;
- (NSString * _Nonnull)getRoot SWIFT_WARN_UNUSED_RESULT;
- (NSString * _Nonnull)getType SWIFT_WARN_UNUSED_RESULT;
- (NSInteger)getBaseFret SWIFT_WARN_UNUSED_RESULT;
- (NSArray<NSNumber *> * _Nonnull)getNotes SWIFT_WARN_UNUSED_RESULT;
- (NSArray<NSString *> * _Nonnull)getNoteNames SWIFT_WARN_UNUSED_RESULT;
- (NSArray<NSNumber *> * _Nonnull)getMidiNotes SWIFT_WARN_UNUSED_RESULT;
- (BOOL)isEqual:(id _Nullable)object SWIFT_WARN_UNUSED_RESULT;
@property (nonatomic, readonly) NSUInteger hash;
- (nonnull instancetype)init SWIFT_UNAVAILABLE;
@end


SWIFT_CLASS("_TtC20FretXAudioProcessing13ChordDetector")
@interface ChordDetector : AudioAnalyzer
- (nonnull instancetype)initWithSampleRate:(float)sampleRate frameShift:(NSInteger)frameShift frameLength:(NSInteger)frameLength targetChords:(NSArray<Chord *> * _Nonnull)targetChords OBJC_DESIGNATED_INITIALIZER;
- (void)setTargetChordsWithChords:(NSArray<Chord *> * _Nonnull)chords;
- (float)getChordSimilarity SWIFT_WARN_UNUSED_RESULT;
@end


SWIFT_CLASS("_TtC20FretXAudioProcessing15FingerPositions")
@interface FingerPositions : NSObject
@property (nonatomic, copy) NSString * _Nonnull name;
@property (nonatomic) NSInteger baseFret;
@property (nonatomic) NSInteger string6;
@property (nonatomic) NSInteger string5;
@property (nonatomic) NSInteger string4;
@property (nonatomic) NSInteger string3;
@property (nonatomic) NSInteger string2;
@property (nonatomic) NSInteger string1;
- (nonnull instancetype)initWithName:(NSString * _Nonnull)name baseFret:(NSInteger)baseFret string6:(NSInteger)string6 string5:(NSInteger)string5 string4:(NSInteger)string4 string3:(NSInteger)string3 string2:(NSInteger)string2 string1:(NSInteger)string1 OBJC_DESIGNATED_INITIALIZER;
- (nonnull instancetype)init SWIFT_UNAVAILABLE;
@end


SWIFT_CLASS("_TtC20FretXAudioProcessing17FretboardPosition")
@interface FretboardPosition : NSObject
- (nonnull instancetype)initWithString:(NSInteger)string fret:(NSInteger)fret OBJC_DESIGNATED_INITIALIZER;
- (uint8_t)getByteCode SWIFT_WARN_UNUSED_RESULT;
- (NSInteger)toMidi SWIFT_WARN_UNUSED_RESULT;
- (NSInteger)getString SWIFT_WARN_UNUSED_RESULT;
- (NSInteger)getFret SWIFT_WARN_UNUSED_RESULT;
- (nonnull instancetype)init SWIFT_UNAVAILABLE;
@end

@class Scale;

SWIFT_CLASS("_TtC20FretXAudioProcessing10MusicUtils")
@interface MusicUtils : NSObject
+ (NSInteger)noteNameToSemitoneNumberWithNoteName:(NSString * _Nonnull)noteName SWIFT_WARN_UNUSED_RESULT;
+ (NSString * _Nonnull)semitoneNumberToNoteNameWithNumber:(NSInteger)number SWIFT_WARN_UNUSED_RESULT;
+ (NSString * _Nonnull)validateNoteNameWithName:(NSString * _Nonnull)name SWIFT_WARN_UNUSED_RESULT;
+ (double)hzToMidiNoteWithHertz:(double)hertz SWIFT_WARN_UNUSED_RESULT;
+ (double)midiNoteToHzWithNote:(NSInteger)note SWIFT_WARN_UNUSED_RESULT;
+ (NSString * _Nonnull)midiNoteToNameWithNote:(NSInteger)note SWIFT_WARN_UNUSED_RESULT;
+ (NSArray<NSNumber *> * _Nonnull)noteNameToMidiNotesWithName:(NSString * _Nonnull)name SWIFT_WARN_UNUSED_RESULT;
+ (FretboardPosition * _Nonnull)midiNoteToFretboardPositionWithNote:(NSInteger)note SWIFT_WARN_UNUSED_RESULT;
+ (double)hzToCentWithHz:(double)hz SWIFT_WARN_UNUSED_RESULT;
+ (double)centToHzWithCent:(double)cent SWIFT_WARN_UNUSED_RESULT;
+ (float)frequencyFromIntervalWithBaseNote:(float)baseNote intervalInSemitones:(NSInteger)intervalInSemitones SWIFT_WARN_UNUSED_RESULT;
+ (FingerPositions * _Nullable)getFingeringWithChordName:(NSString * _Nonnull)chordName SWIFT_WARN_UNUSED_RESULT;
+ (NSArray<NSNumber *> * _Nonnull)leftHandizeBluetoothArrayWithBtArray:(NSArray<NSNumber *> * _Nonnull)btArray SWIFT_WARN_UNUSED_RESULT;
+ (NSArray<NSNumber *> * _Nonnull)getBluetoothArrayFromChordWithChordName:(NSString * _Nonnull)chordName SWIFT_WARN_UNUSED_RESULT;
+ (NSArray<NSNumber *> * _Nonnull)getBluetoothArrayFromScaleWithScale:(Scale * _Nonnull)scale SWIFT_WARN_UNUSED_RESULT;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end


SWIFT_CLASS("_TtC20FretXAudioProcessing17ParameterAnalyzer")
@interface ParameterAnalyzer : NSObject
- (nonnull instancetype)init SWIFT_UNAVAILABLE;
- (void)processWithInput:(float)input;
- (void)addParameterAnalyzerWithPa:(ParameterAnalyzer * _Nonnull)pa;
- (void)removeParameterAnalyzerAtIndex:(NSInteger)index;
- (void)enable;
- (void)disable;
@end


SWIFT_CLASS("_TtC20FretXAudioProcessing20PitchDetectionResult")
@interface PitchDetectionResult : NSObject
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end


SWIFT_CLASS("_TtC20FretXAudioProcessing13PitchDetector")
@interface PitchDetector : AudioAnalyzer
- (nonnull instancetype)initWithSampleRate:(float)sampleRate frameShift:(NSInteger)frameShift frameLength:(NSInteger)frameLength threshold:(float)threshold OBJC_DESIGNATED_INITIALIZER;
@end


SWIFT_CLASS("_TtC20FretXAudioProcessing5Scale")
@interface Scale : NSObject
SWIFT_CLASS_PROPERTY(@property (nonatomic, class, readonly, copy) NSArray<NSString *> * _Nonnull ALL_ROOT_NOTES;)
+ (NSArray<NSString *> * _Nonnull)ALL_ROOT_NOTES SWIFT_WARN_UNUSED_RESULT;
SWIFT_CLASS_PROPERTY(@property (nonatomic, class, readonly, copy) NSArray<NSString *> * _Nonnull ALL_SCALE_TYPES;)
+ (NSArray<NSString *> * _Nonnull)ALL_SCALE_TYPES SWIFT_WARN_UNUSED_RESULT;
- (nonnull instancetype)initWithRoot:(NSString * _Nonnull)root type:(NSString * _Nonnull)type OBJC_DESIGNATED_INITIALIZER;
- (NSArray<FretboardPosition *> * _Nonnull)getFingering SWIFT_WARN_UNUSED_RESULT;
- (NSString * _Nonnull)getRoot SWIFT_WARN_UNUSED_RESULT;
- (NSString * _Nonnull)getType SWIFT_WARN_UNUSED_RESULT;
- (nonnull instancetype)init SWIFT_UNAVAILABLE;
@end

#pragma clang diagnostic pop
